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
#  EKS Variables
####################
variable "vpc_id" {
  type = string
  description = "The IP of the VPC"
}

variable "private_subnets" {
  type = list(string)
}

variable "private_subnets_local_zone" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  description = "EKS cluster version to use"
  type        = string
  default     = ""
}

variable "domain_name_in_route53" {
  type = string
}

variable "service_cidr_block" {
  type        = string
  description = "EKS Service CIDR Block for EKS"
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Number of days to retain EKS logs for control plane"
}

variable "cluster_autoscaler_helm_chart_version" {
  type = string
  description = "Helm Chart Version for Cluster Autoscaler"
}

#-------------------------------
# EKS Cluster VPC Config
#-------------------------------
variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the EKS public API server endpoint is enabled. Default to EKS resource and it is true"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the EKS private API server endpoint is enabled. Default to EKS resource and it is false"
  type        = bool
  default     = false
}

variable "artifactory" {
  type        = list
  description = "Allow artifactory connection with to connect to eks"
}

variable "tags" {
  description = "A map of tags that get added to all resources"
  type        = map(string)
  default     = {}
}
