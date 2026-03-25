locals {
  ng_name       = "demo"
  region        = var.region
  cluster_name  = var.cluster_name
  tags          = var.tags
  cluster_version      = var.cluster_version
  bucket_source        = "${var.environment}-${var.region}-${var.project_name}-source"

  common_tags = {
    Environment = var.environment
    Terraform   = "true"  
  }
}
