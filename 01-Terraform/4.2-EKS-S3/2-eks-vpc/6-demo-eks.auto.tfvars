###################
# General Inputs
###################
region          = "us-east-1"
environment     = "poc"
terraformrole   = "arn:aws:iam::012345678901:role/TerraformRole-Eks" # Delete
days            = 60

###################
# EKS Inputs
###################
domain_name_in_route53 = "demo.com"
vpc_id = "vpc-" # To change
private_subnets = [
  "subnet-", # To change
  "subnet-", # To change
  "subnet-", # To change
]
private_subnets_local_zone = "subnet-" # To change
cluster_name = "demo-lz"
cluster_version = "1.30"

artifactory        = ["172.16.200.0/24"]
service_cidr_block = "192.168.0.0/22"
cloudwatch_log_group_retention_in_days = 180

tags = {
  App_Name = "Kubernetes"
  Country  = "UY"
  Region   = "AMERICA"
}
