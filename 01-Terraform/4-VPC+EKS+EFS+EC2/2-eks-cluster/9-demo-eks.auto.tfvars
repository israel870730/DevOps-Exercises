###################
# General Inputs
###################
region          = "us-west-1"
environment     = "Demo"
project_name    = "demo-eks"
terraformrole   = "arn:aws:iam::012345678901:role/TerraformRole-Eks" # To change

###################
# VPC Inputs
###################
vpc_name               = "demo-eks"
vpc_base_cidr          = "10.1.0.0/16"

availability_zones     = ["us-west-1a", "us-west-1b"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24"
public_subnets         = "10.1.21.0/24,10.1.22.0/24"
isolated_subnets       = "10.1.31.0/24,10.1.32.0/24"

public_subnet_tags = {
"Name"                       = "Public-Subnet"
"kubernetes.io/role/elb"     = 1       # Se puede poner en el fichero locals y optimizar el codigo
"kubernetes.io/cluster/demo" = "owned" # Se puede poner en el fichero locals y optimizar el codigo
}

private_subnet_tags = {
"Name"                            = "Private-Subnet"
"kubernetes.io/role/internal-elb" = 1       # Se puede poner en el fichero locals y optimizar el codigo
"kubernetes.io/cluster/demo"      = "owned" # Se puede poner en el fichero locals y optimizar el codigo
}

###################
# EKS Inputs
###################
cluster_name                    = "demo"
cluster_version                 = "1.28"
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case

instance_types = ["t3.medium"]
#ami_id      = "AMI-ID"
desired_size = 1
min_size     = 1
max_size     = 3


# Aqui dentro de "eks_managed_node_groups" estamos definiendo dos grupos de nodos,
# si tuviesemos un AMI para cada uno de estos grupos de nodos lo podemos definir aqui
# - on_demand
#   - 
# - spot
#   - 
eks_managed_node_groups = {
  on_demand = {
    # desired_size = 1
    # min_size     = 1
    # max_size     = 3

    labels = {
      role = "on_demand"
    }

    #instance_types = ["t3.small"]
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
  App_Name = "Kubernetes"
  Country  = "UY"
  Region   = "AMERICA"
}
