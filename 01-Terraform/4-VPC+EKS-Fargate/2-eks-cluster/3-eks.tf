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
  
  # Probar
  fargate_profiles = {
    staging = {
      fargate_profile_name = "staging"
      # subnet_ids = [
      #   aws_subnet.private_us_east_1a.id,
      #   aws_subnet.private_us_east_1b.id
      # ]
      subnet_ids = module.vpc.private_subnets
      fargate_profile_namespaces = [
        { namespace = "staging" }
      ]
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

module "eks_auth" {
  source     = "aidanmelen/eks-auth/aws"
  eks        = module.eks
  depends_on = [null_resource.merge_kubeconfig]

  map_roles = [
    {
      rolearn  = var.terraformrole
      username = "admin-role"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::012345678901:role/poc"
      username = "admin-role"
      groups   = ["system:masters"]
    }
  ]

  map_users = []

  map_accounts = []
}

module "eks_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
  depends_on = [null_resource.merge_kubeconfig]

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

   enable_aws_efs_csi_driver = true
   aws_efs_csi_driver_helm_config = {
    name        = "aws-efs-csi-driver"
    namespace   = "kube-system"
    description = "The AWS EFS CSI driver Helm chart deployment configuration"
  }
  
  enable_aws_for_fluentbit = true
  aws_for_fluentbit_helm_config = {
    name        = "aws-for-fluent-bit"
    namespace   = "kube-system"
    description = "The AWS Fluent-bit Helm chart deployment configuration"
  }

  enable_aws_cloudwatch_metrics = true
  aws_cloudwatch_metrics_helm_config = {
    name        = "aws-cloudwatch-metrics"
    namespace   = "kube-system"
    description = "The AWS CloudWatch Metrics Helm chart deployment configuration"
  }

  enable_metrics_server = true
  metrics_server_helm_config = {
    name        = "metrics-server"
    namespace   = "kube-system"
    description = "Metrics Server Helm chart deployment configuration"
  }

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller_helm_config = {
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    escription = "aws-load-balancer-controller Helm chart deployment configuration"
  }
  
  tags = local.tags
}

resource "null_resource" "merge_kubeconfig" {

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