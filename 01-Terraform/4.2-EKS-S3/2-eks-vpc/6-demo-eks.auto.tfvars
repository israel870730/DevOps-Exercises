###################
# General Inputs
###################
region          = "us-west-1"
environment     = "poc"
project_name    = "externaldns"
terraformrole   = "arn:aws:iam::114712064551:role/TerraformRole-Eks" # To change
days            = 60

###################
# VPC Inputs
###################
vpc_name               = "demo-externaldns"
vpc_base_cidr          = "10.1.0.0/16"

availability_zones     = ["us-west-1a", "us-west-1b"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24"

public_subnet_tags = {
"Name"                       = "Public-Subnet"
"kubernetes.io/role/elb"     = 1
"kubernetes.io/cluster/demo-externaldns" = "owned"
}

private_subnet_tags = {
"Name"                            = "Private-Subnet"
"kubernetes.io/role/internal-elb" = 1
"kubernetes.io/cluster/demo-externaldns"      = "owned"
}

###################
# EKS Inputs
###################
cluster_name                    = "demo-externaldns"
cluster_version                 = "1.30"
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case

instance_types = ["t3.medium"]
desired_size = 2
min_size     = 1
max_size     = 5

eks_managed_node_groups = {
  on_demand = {
    labels = {
      role = "on_demand"
    }

    capacity_type  = "ON_DEMAND"
  }

  spot = {
    desired_size = 1
    min_size     = 1
    max_size     = 5

    labels = {
      role = "spot"
    }

    instance_types = ["t3.micro"]
    capacity_type  = "SPOT"
  }
}

tags = {
  App_Name = "Kubernetes_externaldns"
  Country  = "UY"
  Region   = "AMERICA"
}
