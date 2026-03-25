locals {
  ng_name       = "demo131"
  region        = var.region
  cluster_name  = var.cluster_name
  tags          = var.tags
  cluster_version    = var.cluster_version
  common_tags = {
    Environment = var.environment
    Terraform   = "true"  
  }
}
