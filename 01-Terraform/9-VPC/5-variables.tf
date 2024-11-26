####################
# General Variables
####################
variable "region" {
  description = "Region"
  type        = string
  default     = "us-west-1"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "poc"
}
