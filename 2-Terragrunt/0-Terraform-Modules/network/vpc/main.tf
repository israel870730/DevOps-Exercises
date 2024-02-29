terraform {
  required_version = ">= 1.0"
}

locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

data "aws_availability_zones" "available" {}

module "this" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  
  name                   = var.vpc_name
  cidr                   = var.vpc_base_cidr

  azs                    = var.availability_zones == [] ? var.availability_zones : data.aws_availability_zones.available.names
  private_subnets        = split(",", var.private_subnets)
  private_subnet_tags    = merge(var.private_subnet_tags, local.common_tags)
  public_subnets         = split(",", var.public_subnets)
  public_subnet_tags     = merge(var.public_subnet_tags, local.common_tags)
  database_subnets       = split(",", var.isolated_subnets)
  database_subnet_tags   = merge(var.isolated_subnet_tags, local.common_tags)

  enable_nat_gateway     = var.enable_nat_gateway
  enable_vpn_gateway     = var.enable_vpn_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  
  tags                   = merge(var.vpc_tags, local.common_tags)
}