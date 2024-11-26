module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.12.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  enable_irsa                     = var.enable_irsa
  #cluster_service_ipv4_cidr = var.service_cidr_block
  #cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  
  # EKS Addons
  # cluster_addons = {
  #   coredns    = {}
  #   kube-proxy = {}
  #   vpc-cni    = {}
  # }

  # Aqui defino los valores predeterminado que van a tener todos los "eks_managed_node_groups"
  eks_managed_node_group_defaults = {
    name             = local.ng_name
    instance_types   = var.instance_types
    #ami_id           = "ami-id"
    ami_id           = data.aws_ami.eks_default.image_id
    min_size         = var.min_size
    max_size         = var.max_size
    desired_size     = var.desired_size
    
    enable_bootstrap_user_data = true
    enable_monitoring       = true
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 25
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          #encrypted             = true
          #kms_key_id            = module.ebs_kms_key.key_arn
          delete_on_termination = true
        }
      }
    }
  }
  
  eks_managed_node_groups         = var.eks_managed_node_groups
  manage_aws_auth_configmap       = var.manage_aws_auth_configmap
  create_aws_auth_configmap       = var.create_aws_auth_configmap
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  #aws_auth_roles                  = [ for aws_auth_role in var.aws_auth_roles : aws_auth_role ]
  #aws_auth_users                  = [ for aws_auth_user in var.aws_auth_users : aws_auth_user ]
  #tags                            = var.tags
  tags                            = merge(var.tags, local.common_tags)

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

# SG of the cluster
resource "aws_security_group_rule" "eks_sg_efs" {
  depends_on = [module.eks]
  description = "Allow EFS traffic"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

resource "aws_security_group_rule" "eks_sg_https" {
  depends_on = [module.eks]
  description = "Allow https traffic to manage the cluster fromthe Jumbox"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

resource "aws_security_group_rule" "eks_allow_all_from_vpc" {
  depends_on = [module.eks]
  description = "Allow all traffic from the vpc"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

# SG of the worker node
resource "aws_security_group_rule" "node_sg_efs" {
  depends_on = [module.eks]
  description = "Allow EFS traffic"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.node_security_group_id 
}

# SG of the worker node -  Allow all 
resource "aws_security_group_rule" "node_sg_allow_all" {
  depends_on = [module.eks]
  description = "Allow all traffic from the vpc"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.node_security_group_id 
}

# Adjuntamos la policy "AmazonSSMFullAccess" para poder acceder a los worker node desde el SSM
# resource "aws_iam_policy_attachment" "attach_amazon_ssm_full_access" {
#   count      = length(keys(module.eks.eks_managed_node_groups))
#   name       = "attach_amazon_ssm_full_access_${keys(module.eks.eks_managed_node_groups)[count.index]}"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  
#   # Accede al nombre del rol IAM de cada grupo de nodos y adjunta la política
#   roles = [
#     module.eks.eks_managed_node_groups[keys(module.eks.eks_managed_node_groups)[count.index]].iam_role_name
#   ]
# }

module "eks_auth" {
  source     = "../../4.1-VPC+EFS-EKS-LocalZone/4-aws-auth/"
  eks        = module.eks
  depends_on = [null_resource.kubeconfig]

  map_roles = [
    {
      rolearn  = "arn:aws:iam::114712064551:role/TerraformRole-Eks" # To change
      username = "admin-role"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::114712064551:role/AWSReservedSSO_AWSAdministratorAccess_e1c02011dbc6c63b" # To change
      username = "admin-role"
      groups   = ["system:masters"]
    }
  ]

  map_users = [
    {
      userarn = "arn:aws:iam::114712064551:user/israel.garcia@verifone.com"
      username = "israel"
      groups   = ["system:masters"]
    },
    {
      userarn = "arn:aws:iam::012345678901:user/poc"
      username = "poc"
      groups   = ["system:masters"]
    }
  ]

  map_accounts = []
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

  # External DNS usando modules/kubernetes-addons
  external_dns_private_zone = true
  eks_cluster_domain = "example.com."

  enable_external_dns      = true
  external_dns_helm_config = {
  name        = "external-dns"
  namespace   = "kube-system"
  description = "ExternalDNS Helm chart deployment configuration"
  values      = [file("${path.module}/values/external_values.yaml")]
  }
  
  enable_aws_efs_csi_driver      = true
  aws_efs_csi_driver_helm_config = {
    name        = "aws-efs-csi-driver"
    namespace   = "kube-system"
    description = "The AWS EFS CSI driver Helm chart deployment configuration"
  }

  enable_aws_for_fluentbit      = true
  aws_for_fluentbit_helm_config = {
    name        = "aws-for-fluent-bit"
    namespace   = "fluentbit"
    description = "The AWS Fluent-bit Helm chart deployment configuration"
    values = [templatefile("${path.module}/values/fluentbit_values.yaml", {
      region = var.region
      logGroupName = "${module.eks.cluster_name}-fluentbit"
      bucket_name =  local.bucket_name
      clusterName = "${module.eks.cluster_name}"
    })]
  }

  enable_aws_cloudwatch_metrics      = true
  aws_cloudwatch_metrics_helm_config = {
    name        = "aws-cloudwatch-metrics"
    namespace   = "kube-system"
    description = "The AWS CloudWatch Metrics Helm chart deployment configuration"
  }

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
    escription = "aws-load-balancer-controller Helm chart deployment configuration"
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

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}