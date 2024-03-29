terraform {
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.22.0"

      # skip_get_ec2_platforms     = true
      # skip_metadata_api_check    = true
      # skip_region_validation     = true
      # skip_requesting_account_id = true
    }
  }
}

provider "aws" {
  region = var.region
}