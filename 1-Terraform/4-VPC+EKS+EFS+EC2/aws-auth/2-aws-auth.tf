module "eks-aws-auth" {
  source     = "../Module-aws-auth/"

  map_roles  = var.map_roles
  map_users  = var.map_users 
}
