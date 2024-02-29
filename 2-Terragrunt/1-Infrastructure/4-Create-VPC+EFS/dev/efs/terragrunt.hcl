terraform {
  source = "../../../../Terraform-Modules/storage/efs/"
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
  environment                 = include.env.locals.env
  vpc_id                      = dependency.vpc.outputs.vpc_id
  private_subnets             = dependency.vpc.outputs.private_subnets
  private_subnets_cidr_blocks = [
    #module.vpc.private_cidr_blocks[0],
    #module.vpc.private_cidr_blocks[1],
    dependency.vpc.private_cidr_blocks[0],
    dependency.vpc.private_cidr_blocks[1],
  ]
}

dependency "vpc" {
  config_path = "../vpc"
}