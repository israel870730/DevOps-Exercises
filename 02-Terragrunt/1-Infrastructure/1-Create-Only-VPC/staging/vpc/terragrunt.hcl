terraform {
  source = "../../../../Terraform-Modules/network/vpc/"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_name               = "Staging"
  vpc_base_cidr          = "10.0.0.0/16"

  azs                    = ["us-west-1a", "us-west-1b"]
  private_subnets        = "10.0.11.0/24,10.0.12.0/24"
  public_subnets         = "10.0.21.0/24,10.0.22.0/24"
  isolated_subnets       = "10.0.31.0/24,10.0.32.0/24"
  environment            = "Staging"

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/dev-demo"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/dev-demo" = "owned"
  }
}