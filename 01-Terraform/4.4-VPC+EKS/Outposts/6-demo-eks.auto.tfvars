###################
# General Inputs
###################
region          = "eu-central-1"
environment     = "poc"
project_name    = "poc-outposts"
terraformrole   = "arn:aws:iam::154926407884:role/EKS-PlatformSetup-Role" # To change
days            = 60

###################
# VPC Inputs
###################
vpc_name               = "poc-outposts"
vpc_base_cidr          = "10.1.0.0/16"

availability_zones     = ["eu-central-1c", "eu-central-1b"]
private_subnets        = "10.1.11.0/24,10.1.12.0/24"
public_subnets         = "10.1.31.0/24,10.1.32.0/24"


public_subnet_tags = {
"Name"                                   = "Public-Subnet"
"kubernetes.io/role/elb"                 = 1
"kubernetes.io/role/internal-elb"        = 1
"kubernetes.io/cluster/poc-outposts" = "owned" # CLuster Name
}

private_subnet_tags = {
"Name"                                   = "Private-Subnet"
"kubernetes.io/role/elb"                 = 1
"kubernetes.io/role/internal-elb"        = 1
"kubernetes.io/cluster/poc-outposts" = "owned" # CLuster Name
}

###################
# EKS Inputs
###################
cluster_name                    = "poc-outposts"
cluster_version                 = "1.32"
#ami_id                          = "ami-0f69abc1b558686e8" # amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
#ami_id                          = "ami-0c834fa666e5127b5" # amazon-eks-node-al2023-x86_64-standard-1.32-v20250212
cluster_endpoint_private_access = false # To change in real case
cluster_endpoint_public_access  = true  # To change in real case
service_cidr_block = "172.20.0.0/16"

instance_type = "m5.large"
desired_size = 1
min_size     = 1
max_size     = 3

eks_managed_node_groups = {
  outposts-al2023 = {
    labels = {
      role = "on_demand"
    }
    capacity_type  = "ON_DEMAND"
  }
}

tags = {
  App_Name = "Kubernetes_externaldns"
  Country  = "UY"
  Region   = "AMERICA"
}
