###################
# General Inputs
###################
region          = "us-east-1"
environment     = "poc"
project_name    = "demo"
terraformrole   = "arn:aws:iam::012345678901:role/TerraformRole-Eks"
days            = 60
admin_sso_role_arn = "arn:aws:iam::012345678901:role/AWSReservedSSO_AWSAdministratorAccess_fg672023457jk5488c"

###################
# VPC Inputs
###################
vpc_name               = "demo"
vpc_base_cidr          = "10.1.0.0/16"
private_subnets        = "10.1.11.0/24,10.1.12.0/24,10.1.13.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24,10.1.23.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24,10.1.33.0/24"

public_subnet_tags = {
  "Name"                              = "Public-Subnet"
  "kubernetes.io/role/elb"            = 1
  "kubernetes.io/role/internal-elb"   = 1
  "kubernetes.io/cluster/demo-al2023" = "owned" # CLuster Name
}

private_subnet_tags = {
  "Name"                              = "Private-Subnet"
  "kubernetes.io/role/elb"            = 1
  "kubernetes.io/role/internal-elb"   = 1
  "kubernetes.io/cluster/demo-al2023" = "owned" # CLuster Name
}

###################
# EKS Inputs
###################
cluster_name                    = "demo"
cluster_version                 = "1.35"
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case

instance_types = ["t3.small","t3.medium","t3.large"]
desired_size = 2
min_size     = 1
max_size     = 5

cloudwatch_log_group_retention_in_days = 5
service_cidr_block = "192.168.0.0/22"

tags = {
  Country  = "UY"
  Region   = "AMERICA"
}
