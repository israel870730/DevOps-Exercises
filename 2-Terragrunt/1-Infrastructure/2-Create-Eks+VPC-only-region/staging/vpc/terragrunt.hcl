terraform {
  source = "../../../../Terraform-Modules/network/vpc/"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path              = find_in_parent_folders("env.hcl")
  expose            = true
  merge_strategy    = "no_merge"
}

inputs = {
  vpc_name               = include.env.locals.vpc_name
  vpc_base_cidr          = "10.0.0.0/16"

  azs                    = ["us-west-1a", "us-west-1b"]
  private_subnets        = "10.0.11.0/24,10.0.12.0/24"
  public_subnets         = "10.0.21.0/24,10.0.22.0/24"
  isolated_subnets       = "10.0.31.0/24,10.0.32.0/24"
  environment            = include.env.locals.env

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"     = 1
    "kubernetes.io/cluster/${include.env.locals.cluster_name}"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"             = 1
    "kubernetes.io/cluster/${include.env.locals.cluster_name}"  = "owned"
  }
}