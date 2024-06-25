####################
# General Variables
####################

variable "region" {
  description = "Region"
  type = string
  default = ""
}

variable "terraformrole" {
  description = "provisioner role "
  type        = string
}

variable cluster_name {
  description = "Name EKS cluster is created with"
  type        = string
  default     = ""
}

####################
# AWS-AUTH Variables
####################

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}