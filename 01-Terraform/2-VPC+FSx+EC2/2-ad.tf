resource "aws_directory_service_directory" "fsx_ad" {
  name     = "fsxpoc.com"
  password = var.ad_password
  edition  = "Standard"
  type     = "MicrosoftAD"

  #for_each = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
  vpc_settings {
    vpc_id     = module.vpc.vpc_id
    subnet_ids       = module.vpc.private_subnets
    #subnet_ids = var.subnet_ids
  }

  tags = {
    Project     = "Test"
    Environment = var.environment
  }
}