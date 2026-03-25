locals {
  region               = var.region
  bucket_source        = "${var.environment}-${var.region}-${var.project_name}-source"
  bucket_log           = "${var.environment}-${var.region}-${var.project_name}-log"
  bucket_destination   = "${var.environment}-${var.region}-${var.project_name}-destination"

  tags            = var.tags
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}