locals {
  ng_name       = "demo"
  region        = var.region
  cluster_name  = var.cluster_name
  name          = basename(path.cwd)
  bucket_name  = "${var.environment}-${var.region}-${var.project_name}-eks-log"
  tags          = var.tags
  cluster_version    = var.cluster_version
  common_tags = {
    Environment = var.environment
    Terraform   = "true"  
  }
}
