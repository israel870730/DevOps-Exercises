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

variable "project_name" {
  type        = string
  description = "Name of the project, will be used as prefix in resources names"
}

variable "tags" {
  description = "A map of tags that get added to all resources"
  type        = map(string)
  default     = {}
}