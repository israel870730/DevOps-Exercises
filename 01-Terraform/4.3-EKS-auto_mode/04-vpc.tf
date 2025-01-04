module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "DemoAutoMode"
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
    "kubernetes.io/cluster/DemoAutoMode" = "shared"
    "kubernetes.io/role/elb"            = "1"
    "kubernetes.io/cluster/DemoAutoMode" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/DemoAutoMode" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/DemoAutoMode" = "owned"
  }
}
