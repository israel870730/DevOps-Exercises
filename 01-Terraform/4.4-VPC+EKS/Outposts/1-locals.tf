locals {
  ng_name       = "outposts"
  region        = var.region
  cluster_name  = var.cluster_name
  tags          = var.tags
  cluster_version    = var.cluster_version
  common_tags = {
    Environment = var.environment
    Terraform   = "true"  
  }
}

locals {
  cert_base64 = module.eks.cluster_certificate_authority_data
}