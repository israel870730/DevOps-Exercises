###################
# General Inputs
###################
#region          = "us-east-1"
region          = "eu-west-3"

environment     = "poc"
project_name    = "demo-al2023"
terraformrole   = "arn:aws:iam::Account-ID:role/TerraformRole-Eks" # To change
days            = 60

###################
# VPC Inputs
###################
vpc_name               = "demo-al2023"
vpc_base_cidr          = "10.1.0.0/16"

#availability_zones     = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24,10.1.13.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24,10.1.23.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24,10.1.33.0/24"

public_subnet_tags = {
  "Name"                                   = "Public-Subnet"
  "kubernetes.io/role/elb"                 = 1
  "kubernetes.io/role/internal-elb"        = 1
  "kubernetes.io/cluster/demo-al2023" = "owned" # CLuster Name
}

private_subnet_tags = {
  "Name"                                   = "Private-Subnet"
  "kubernetes.io/role/elb"                 = 1
  "kubernetes.io/role/internal-elb"        = 1
  "kubernetes.io/cluster/demo-al2023" = "owned" # CLuster Name
}

###################
# EKS Inputs
###################
cluster_name                    = "demo-al2023"
cluster_version                 = "1.32"
#ami_id                          = "ami-0f69abc1b558686e8" # amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
#ami_id                          = "ami-0c834fa666e5127b5" # amazon-eks-node-al2023-x86_64-standard-1.32-v20250212
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case

instance_types = ["t3.medium"]
desired_size = 2
min_size     = 1
max_size     = 5

cloudwatch_log_group_retention_in_days = 5
service_cidr_block = "192.168.0.0/22"

# eks_managed_node_groups = {
#   on_demand-al2023 = {
#     labels = {
#       role = "on_demand"
#     }
#     capacity_type  = "ON_DEMAND"
#   }
#   spot = {
#     desired_size = 1
#     min_size     = 1
#     max_size     = 3
#     labels = {
#       role = "spot"
#     }
#     instance_types = ["t3.micro"]
#     capacity_type  = "SPOT"
#   }
# }

tags = {
  App_Name = "Kubernetes_externaldns"
  Country  = "UY"
  Region   = "AMERICA"
}
