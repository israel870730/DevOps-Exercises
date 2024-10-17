provider "aws" {
  region = local.region
  #Tags to All Resources
  default_tags {
    tags = local.tags
  }
}