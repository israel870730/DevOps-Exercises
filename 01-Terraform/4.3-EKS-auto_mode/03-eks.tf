# https://github.com/terraform-aws-modules/terraform-aws-eks/tree/v20.31.0
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  #vpc_id     = "vpc-ID"
  #subnet_ids = ["subnet-ID", "subnet-DI"]
  
  tags = {
    Environment = "Dev"
    Terraform   = "true"
  }
}