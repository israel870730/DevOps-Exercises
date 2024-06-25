module "sg" {
  source = "../../network/security-groups/"

  security_group_name     = var.security_group_name
  description             = var.description 
  vpc_id                  = module.vpc.vpc_id

  ingress_rules           = var.ingress_rules
  ingress_cidr_blocks = [
    module.vpc.private_cidr_blocks[0], # Cambia el índice según sea necesario
    module.vpc.private_cidr_blocks[1], # Cambia el índice según sea necesario
  ]

  egress_rules            = var.egress_rules
  egress_cidr_blocks      = var.egress_cidr_blocks

  tags                    = var.tags
}
