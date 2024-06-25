locals {
  region  = "us-west-1"
  ami     = var.ubuntu_ami[local.region]
  tags    = {
    Environment   = "POC",
    Terraform     = "True" 
  }
  az_to_index = {
    "a" = 0
    "b" = 1
  }
}