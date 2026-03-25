module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "20.37.2"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  enable_irsa                     = var.enable_irsa
  authentication_mode             = "API_AND_CONFIG_MAP"
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  cluster_service_ipv4_cidr       = var.service_cidr_block
  enable_cluster_creator_admin_permissions = true
  cloudwatch_log_group_retention_in_days   = var.cloudwatch_log_group_retention_in_days

  # Cifrado de secretos (en reposo) con KMS administrado por este módulo
  cluster_encryption_config = { resources = ["secrets"] }
  create_kms_key            = true

  # Add-ons administrados por EKS
  cluster_addons = {
    # VPC CNI primero, así los nodos ya nacen con la config correcta
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
  }
  
  # ===== Managed Node Group con AMI personalizada AL2023 =====
  eks_managed_node_groups = {
    ng-custom = {
      ami_type = "AL2023_x86_64_STANDARD" # Esto es para AL2023
      name     = "custom-demo-al2023"
      capacity_type              = "SPOT"
      ami_id   = data.aws_ami.eks_default_al2023.image_id

      instance_types = var.instance_types
      min_size       = 1
      max_size       = 3
      desired_size   = 1

      enable_bootstrap_user_data = true
      enable_monitoring       = true

      update_config = {
        max_unavailable_percentage = 33
      }

      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    },
  }

  tags = merge(var.tags, local.common_tags)

  # Agregar una regla nueva al SG del los worker node 
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
}

module "aws_auth" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks//modules/aws-auth?ref=v20.37.2"

  manage_aws_auth_configmap = true

  aws_auth_roles = concat(
    [
      {
        rolearn  = var.terraformrole
        username = "terraform-role-Eks"
        groups   = ["system:masters"]
      },
      {
        rolearn  = var.admin_sso_role_arn
        username = "admin-role"
        groups   = ["system:masters"]
      }
    ],
    [
      for ng in module.eks.eks_managed_node_groups :
      {
        rolearn  = ng.iam_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ]
  )

  depends_on = [module.eks]
}

# eks kubernetes addons
# https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/v4.32.1
module "eks_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
  depends_on = [null_resource.kubeconfig]

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

  enable_cluster_autoscaler = true

  enable_metrics_server      = true
  metrics_server_helm_config = {
    name        = "metrics-server"
    namespace   = "kube-system"
    description = "Metrics Server Helm chart deployment configuration"
  }

  enable_aws_load_balancer_controller      = true
  aws_load_balancer_controller_helm_config = {
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    description = "aws-load-balancer-controller Helm chart deployment configuration"
     version     = "3.1.0"
    values = [templatefile("${path.module}/values/aws_lb_controller_values.yaml", {
      cluster_name = var.cluster_name
      tags_values = indent(2, yamlencode(local.tags))
      bucket_name = local.bucket_source
    })]
  }

  tags = local.tags
}

resource "null_resource" "kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Updating Kube config file'
      # aws sts get-caller-identity
      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
             $(aws sts assume-role \
                   --role-arn ${var.terraformrole} \
                   --role-session-name Jenkins-EKS-Setup \
                   --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
                   --output text))
      aws sts get-caller-identity
      aws eks wait cluster-active --name '${module.eks.cluster_name}'  --region '${local.region}'
      aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}
    EOT
  }
}

data "aws_ami" "eks_default_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    #amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
    values = ["amazon-eks-node-al2023-x86_64-standard-${var.cluster_version}-v*"]
  }
}

data "aws_iam_role" "alb_controller" {
  name = "${var.cluster_name}-aws-load-balancer-controller-sa-irsa"
  depends_on = [module.eks_kubernetes_addons]
}

resource "aws_iam_policy" "alb_extra" {
  name = "${local.cluster_name}-alb-controller-extra"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:DescribeListenerAttributes",
          "elasticloadbalancing:RemoveTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_extra" {
  role       = data.aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_extra.arn
  depends_on = [module.eks_kubernetes_addons]
}

# resource "aws_iam_role_policy_attachment" "alb_controller_official" {
#   role       = data.aws_iam_role.alb_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
# }