locals {
  region = "us-west-1"
  environment = "poc"
  bucket_name  = "${local.environment}-${local.region}-sftp"
  tags = {
    Environment   = "POC",
    Terraform     = "True" 
  }
}