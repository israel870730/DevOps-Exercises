locals {
  region      = "us-west-1"
  tags = {
    Environment   = "POC",
    Terraform     = "True" 
    App1          = "True"
  }
}