locals {
  region             = var.region
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  tags               = var.tags
  common_tags        = {
    Environment = var.environment
    Terraform   = "true"  
  }
}
