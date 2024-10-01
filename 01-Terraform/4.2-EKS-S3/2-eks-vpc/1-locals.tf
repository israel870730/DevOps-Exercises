locals {
  ng_name       = "demo-localzone"
  region        = var.region
  cluster_name  = var.cluster_name
  name          = basename(path.cwd)
  bucket_name  = "${var.environment}-${var.region}-eks-pod-log"
  tags          = var.tags
  cluster_version    = var.cluster_version
  domain_for_route53 = var.domain_name_in_route53
  common_tags = {
    Environment = var.environment
    Terraform   = "true"  
  }
}
