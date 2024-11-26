locals {
  region = var.region
  tags   = {
    Environment   = "POC",
    Terraform     = "True" 
  }
}