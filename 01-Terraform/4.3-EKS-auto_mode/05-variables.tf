####################
# General Variables
####################
variable "region" {
  description = "Region"
  type = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "POC"
}

####################
#  EKS Variables
####################
variable cluster_name {
  description = "Name EKS cluster is created with"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version to use"
  type        = string
}

variable "tags" {
  description = "A map of tags that get added to all resources"
  type        = map(string)
  default     = {}
}