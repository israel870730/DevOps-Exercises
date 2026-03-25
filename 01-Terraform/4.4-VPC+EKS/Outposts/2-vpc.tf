#https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/outpost
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_base_cidr
  azs                    = var.availability_zones == [] ? var.availability_zones : data.aws_availability_zones.available.names
  #azs                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets        = split(",", var.private_subnets)
  private_subnet_tags    = merge(var.private_subnet_tags, local.common_tags)
  public_subnets         = split(",", var.public_subnets)
  public_subnet_tags     = merge(var.public_subnet_tags, local.common_tags)
  #database_subnets       = split(",", var.isolated_subnets)
  #database_subnet_tags   = merge(var.isolated_subnet_tags, local.common_tags)
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  enable_vpn_gateway     = var.enable_vpn_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  tags                   = merge(var.vpc_tags, local.common_tags)
  outpost_arn     = data.aws_outposts_outpost.shared.arn
  outpost_az      = data.aws_outposts_outpost.shared.availability_zone
}

data "aws_availability_zones" "available" {}


data "aws_outposts_outpost" "shared" {
  name = "ath50-otl-rack3"
}

resource "aws_subnet" "outpost_subnet1" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.1.21.0/24"
  availability_zone = "eu-central-1c"
  outpost_arn       = data.aws_outposts_outpost.shared.arn

  tags = {
    Name = "outpost-subnet"
  }
}

resource "aws_route_table_association" "outpost_assoc_subnet1" {
  subnet_id      = aws_subnet.outpost_subnet1.id
  route_table_id = module.vpc.private_route_table_ids[0]

  depends_on = [module.vpc]
}

resource "aws_subnet" "outpost_subnet2" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.1.22.0/24"
  availability_zone = "eu-central-1c"
  outpost_arn       = data.aws_outposts_outpost.shared.arn

  tags = {
    Name = "outpost-subnet"
  }
}

resource "aws_route_table_association" "outpost_assoc_subnet2" {
  subnet_id      = aws_subnet.outpost_subnet2.id
  route_table_id = module.vpc.private_route_table_ids[0]

   depends_on = [module.vpc]
}
