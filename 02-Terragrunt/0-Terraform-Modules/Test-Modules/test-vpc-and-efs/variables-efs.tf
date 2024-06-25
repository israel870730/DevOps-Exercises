variable "environment" {
  description = "Environmen to create resources in"
  type        = string
  default     = "Dev"
}

# variable "vpc_id_efs" {
#   description = "ID of VPC to create security group"
#   type        = string
#   default     = ""
# }

# variable "private_subnets_efs" {
#   description = "private subnets"
#   type        = string
# }

# variable "private_subnets_cidr_blocks_efs" {
#   description = "private subnets"
#   type        = string
# }