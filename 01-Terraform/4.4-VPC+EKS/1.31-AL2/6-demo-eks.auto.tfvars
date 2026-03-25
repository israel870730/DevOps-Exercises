###################
# General Inputs
###################
region          = "us-east-1"
environment     = "poc"
project_name    = "demo-new-relic"
terraformrole   = "arn:aws:iam::012345678901:role/TerraformRole-Eks" # To change
days            = 60

###################
# VPC Inputs
###################
vpc_name               = "demo-new-relic"
vpc_base_cidr          = "10.1.0.0/16"

availability_zones     = ["us-east-1a", "us-east-1a", "us-east-1a"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24,10.1.13.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24,10.1.23.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24,10.1.33.0/24"

public_subnet_tags = {
"Name"                                   = "Public-Subnet"
"kubernetes.io/role/elb"                 = 1
"kubernetes.io/role/internal-elb"        = 1
"kubernetes.io/cluster/demo-new-relic" = "owned" # CLuster Name
}

private_subnet_tags = {
"Name"                                   = "Private-Subnet"
"kubernetes.io/role/elb"                 = 1
"kubernetes.io/role/internal-elb"        = 1
"kubernetes.io/cluster/demo-new-relic" = "owned" # CLuster Name
}

###################
# EKS Inputs
###################
cluster_name                    = "demo-new-relic"
cluster_version                 = "1.31"
#ami_id                          = "ami-0f69abc1b558686e8" # amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
#ami_id                          = "ami-0c834fa666e5127b5" # amazon-eks-node-al2023-x86_64-standard-1.32-v20250212
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case

instance_types = ["t3.medium"]
desired_size = 1
min_size     = 1
max_size     = 1

eks_managed_node_groups = {
  on_demand = {
    labels = {
      role = "on_demand"
    }

    capacity_type  = "ON_DEMAND"
  }

  # spot = {
  #   desired_size = 3
  #   min_size     = 1
  #   max_size     = 5

  #   labels = {
  #     role = "spot"
  #   }

  #   instance_types = ["t3.micro"]
  #   capacity_type  = "SPOT"
  # }
}

tags = {
  App_Name = "Kubernetes_externaldns"
  Country  = "UY"
  Region   = "AMERICA"
}
