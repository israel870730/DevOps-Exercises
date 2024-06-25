###################
# Common Inputs
###################
region = "us-west-1"

###################
# VPC Inputs
###################
vpc_name               = "poc"
vpc_base_cidr          = "10.1.0.0/16"

availability_zones     = ["us-west-1a", "us-west-1b"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24"


###################
# EFS Inputs
###################

# efs_name = "poc-efs"
# tags = {
#   Type     = "App"
#   App      = "Kubernetes"
# }