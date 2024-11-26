module "vpc-1" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "vpc-1"
  cidr = "10.1.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.1.0.0/19", "10.1.32.0/19"]
  public_subnets  = ["10.1.64.0/19", "10.1.96.0/19"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "Name"                       = "public-subnet-vpc-1"
    "kubernetes.io/role/elb"     = 1
    "kubernetes.io/cluster/demo" = "owned"
  }

  private_subnet_tags = {
    "Name"                       = "private-subnet-vpc-1"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

module "vpc-2" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "vpc-2"
  cidr = "10.2.0.0/16"

  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.2.0.0/19", "10.2.32.0/19"]
  public_subnets  = ["10.2.64.0/19", "10.2.96.0/19"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "Name"                       = "public-subnet-vpc-2"
    "kubernetes.io/role/elb"     = 1
    "kubernetes.io/cluster/demo" = "owned"
  }

  private_subnet_tags = {
    "Name"                       = "private-subnet-vpc-2"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/demo"      = "owned"
  }
}