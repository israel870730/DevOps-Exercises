variable "security_group_name" {
  description = "Name of security group"
  type        = string
  default     = "this_security_group"
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "environment" {
  description = "Environment where resources are deployed"
  type        = string
  default     = "Dev"
}

variable "ingress_rules" {
  description = "List of pre defined rules for ingress e.g. ssh-tcp"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "Ingress CIDR blocks used to allow ingress access"
  type        = list(string)
  default     = null
}

variable "egress_rules" {
  description = "List of pre defined rules for egress e.g. ssh-tcp"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "Egress CIDR blocks used to allow ingress access"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default     = null
}