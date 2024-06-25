module "vpc" {
  source = "../../network/vpc/"

  vpc_name               = var.vpc_name
  vpc_base_cidr          = var.vpc_base_cidr

  availability_zones     = var.availability_zones
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  isolated_subnets       = var.isolated_subnets

  # private_subnet_tags = {
  #   "kubernetes.io/role/internal-elb"     = 1
  #   "kubernetes.io/cluster/cluster-name"  = "owned"
  # }

  # public_subnet_tags = {
  #   "kubernetes.io/role/elb"             = 1
  #   "kubernetes.io/cluster/cluster-name" = "owned"
  # }

}