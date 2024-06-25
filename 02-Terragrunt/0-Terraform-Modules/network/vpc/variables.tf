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
  type        = string
  default     = "false"
}

variable "enable_dns_support" {
  description = "enable DNS support"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "Dev"
}

variable "vpc_tags" {
  description = "Arbritary tags for VPC"
  type        = map
  default     = {}
}