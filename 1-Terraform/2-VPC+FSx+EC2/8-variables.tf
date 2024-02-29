# variable "ad_name" {
#   description = "AD name"
#   type = string
# }

variable "ad_password" {
  description = "AD password"
  type = string
  default = "@123456POC2024*"
}

variable "environment" {
  description = "Environmen to create resources in"
  type        = string
  default     = "Dev"
}

# variable "role_name" {
#   description = "Role Name to FSx"
#   type = string
#   default = ""  
# }