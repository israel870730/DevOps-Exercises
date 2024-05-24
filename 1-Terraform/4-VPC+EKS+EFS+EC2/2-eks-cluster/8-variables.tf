####################
# General Variables
####################
variable "region" {
  description = "Region"
  type = string
  default = ""
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "Dev"
}

variable "terraformrole" {
  description = "Terraform Role"
  type        = string
}

####################
#  VPC Variables
####################
variable "create_vpc" {
  description = "Whether to create VPC"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
}

variable "vpc_base_cidr" {
  description = "default cidr block"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones in the Region"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "private subnets"
  type        = string
}

variable "private_subnet_tags" {
  description = "Tags to be attached to private subnets"
  type        = map
  default = {
    Name = "Private"
  }
}

variable "public_subnets" {
  description = "public subnets"
  type        = string
}

variable "public_subnet_tags" {
  description = "Tags to be attached to public subnets"
  type        = map
  default = {
    Name = "Public"
  }
}

variable "isolated_subnets" {
  description = "isolated from the internet"
  type        = string
}

variable "isolated_subnet_tags" {
  description = "Tags to be attached to isolated subnets"
  type        = map
  default = {
    Name = "Isolated"
  }
}

variable "enable_nat_gateway" {
  description = "enable nat gateway"
  default     = true
}

variable "single_nat_gateway" {
  description = "enable nat gateway"
  default     = true
}

variable "enable_vpn_gateway" {
  description = "enable vpn gateway"
  default     = true
}

variable "enable_dns_hostnames" {
  description = "enable DNS hostnames"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "ensure only one nat gateway is craeted per az"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "enable DNS support"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Arbritary tags for VPC"
  type        = map
  default     = {}
}

####################
#  EKS Variables
####################
variable cluster_name {
  description = "Name EKS cluster is created with"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "EKS cluster version to use"
  type        = string
  default     = ""
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
}

variable "vpc_id" {
  description = "ID for the VPC to deploy EKS cluster"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "Subnets that run the EKS Worker Nodes"
  type        = list(string)
  default     = null
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}

variable "manage_aws_auth_configmap" {
  description = "Determines whether to manage the aws-auth configmap"
  type        = bool
  default     = false
}

variable "create_aws_auth_configmap" {
  description = "Determines whether to create the aws-auth configmap. NOTE - this is only intended for scenarios where the configmap does not exist (i.e. - when using only self-managed node groups). Most users should use `manage_aws_auth_configmap`"
  type        = bool
  default     = false
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit", "api", "authenticator","controllerManager","scheduler"]
}

variable "tags" {
  description = "A map of tags that get added to all resources"
  type        = map(string)
  default     = {}
}

# variable "aws_auth_roles" {
#   description = "List of role maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# variable "aws_auth_users" {
#   description = "List of user maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

variable "project_name" {
  type        = string
  description = "Name of the project, will be used as prefix in resources names"
}

variable "instance_types" {
  type        = list(any)
  description = "Types of AWS Instance"
}

# variable "ami_id" {
#   type        = string
#   description = "Node AMI ID from which EKS nodes will be derived."
# }

variable "min_size" {
  type        = number
  description = "The minimum number of nodes that the managed node group can scale in to."
}

variable "max_size" {
  type        = number
  description = "The maximum number of nodes that the managed node group can scale out to."
}

variable "desired_size" {
  type        = number
  description = "The current number of nodes that the managed node group should maintain."
}

# variable "min_size" {
#   type        = number
#   description = "The minimum number of nodes that the managed node group can scale in to."
# }

# variable "max_size" {
#   type        = number
#   description = "The maximum number of nodes that the managed node group can scale out to."
# }

# variable "desired_size" {
#   type        = number
#   description = "The current number of nodes that the managed node group should maintain."
# }

# variable "instance_types" {
#   type        = list(any)
#   description = "Types of AWS Instance"
# }

# variable "ami_id" {
#   type        = string
#   description = "Node AMI ID from which EKS nodes will be derived."
# }
