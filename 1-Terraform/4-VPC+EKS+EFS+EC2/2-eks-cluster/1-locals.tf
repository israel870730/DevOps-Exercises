locals {
  ng_name     = "demo-eks"
  region      = var.region
  tags        = var.tags
  cluster_name = var.cluster_name
  common_tags = {
    Environment = var.environment
    project_name = var.project_name
    Terraform   = "true"  
  }
}