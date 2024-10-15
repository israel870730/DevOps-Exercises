####################
# General Variables
####################
variable "region" {
  description = "Region"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "Dev"
}

variable "terraformrole" {
  description = "Terraform Role"
  type        = string
  default     = ""
}

####################
#  EKS Variables
####################
variable "vpc_id" {
  type = string
  description = "The IP of the VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet of the AZs"
}

variable "private_subnets_local_zone" {
  type        = string
  description = "Private subnet of the Local zone"
}

variable "cluster_name" {
  type        = string
  description = "Cluste name"
}

variable "cluster_version" {
  description = "EKS cluster version to use"
  type        = string
  default     = ""
}

variable "service_cidr_block" {
  type        = string
  description = "EKS Service CIDR Block for EKS"
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  description = "Number of days to retain EKS logs for control plane"
}

variable "domain_name_in_route53" {
  type = string
}

##########################
# EKS Cluster VPC Config
##########################

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

####################
#  S3 Variables
####################

variable "days" {
  description = "No. of days for retention of logs in s3 "
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