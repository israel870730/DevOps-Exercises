module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name = "main-module"
  cidr = "10.0.0.0/16"
  azs             = ["us-west-1a", "us-west-1b"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "Name"                       = "public-subnet"
    "kubernetes.io/role/elb"     = 1
    "kubernetes.io/cluster/demo" = "owned"
  }
  
  private_subnet_tags = {
    "Name"                       = "private-subnet"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/demo"      = "owned"
  }
}