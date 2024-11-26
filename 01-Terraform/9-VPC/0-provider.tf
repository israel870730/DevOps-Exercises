provider "aws" {
  #region = "us-west-1"
  region = local.region
  
  #Tags to All Resources
  default_tags {
    tags = local.tags
  }
}