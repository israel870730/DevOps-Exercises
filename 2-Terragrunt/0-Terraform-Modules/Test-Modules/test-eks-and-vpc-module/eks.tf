module "eks" {
  source = "../../compute/eks/"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  region                          = var.region
  vpc_id                          = module.vpc.vpc_id
  subnets                         = module.vpc.private_subnets

  eks_managed_node_groups         = var.eks_managed_node_groups
  manage_aws_auth_configmap       = var.manage_aws_auth_configmap
  aws_auth_roles                  = var.aws_auth_roles
  aws_auth_users                  = var.aws_auth_users
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  tags                            = var.tags
  project_name                    = var.project_name
  
}
