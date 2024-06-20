provider "aws" {
  region = "us-west-1"
  
  #Tags to All Resources
  default_tags {
    tags = local.tags
  }
}