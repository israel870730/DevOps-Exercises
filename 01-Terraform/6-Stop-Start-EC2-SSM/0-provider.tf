provider "aws" {
  region = local.region
  # Con esta opcion hacemos que todos los recursos creados tengan los "TAG" definidos en el fichero "locals"
  default_tags {
   tags = local.tags
  }
}