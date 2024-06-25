module "efs" {
  source = "../../storage/efs/"
  
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets
  private_subnets_cidr_blocks = [
    module.vpc.private_cidr_blocks[0], # Cambia el índice según sea necesario
    module.vpc.private_cidr_blocks[1], # Cambia el índice según sea necesario
  ]
}