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


variable "public_subnets" {
  description = "public subnets"
  type        = string
}

variable "isolated_subnets" {
  description = "isolated from the internet"
  type        = string
}
