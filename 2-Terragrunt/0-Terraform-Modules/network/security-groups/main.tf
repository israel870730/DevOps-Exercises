terraform {
  required_version = ">= 1.0"
}

locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# data "aws_vpc" "default" {
#   id = var.vpc_id
# }

# data "aws_subnet" "default" {
#   vpc_id = var.vpc_id
#   filter {
#     name   = "tag:Name"
#     values = ["Private"]
#   }
# }

module "this" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "3.1.0"

  name                    = var.security_group_name
  description             = var.description
  vpc_id                  = var.vpc_id
  create                  = var.create
  ingress_rules           = var.ingress_rules
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  egress_rules            = var.egress_rules
  egress_ipv6_cidr_blocks = []
  rules                   = var.rules
  tags                    = merge(var.tags, local.common_tags)
  use_name_prefix         = var.use_name_prefix
  
}