provider "aws" {
  region = local.region
  
  default_tags {
    tags = local.tags
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}
