# remote_state {
#   backend = "local"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }

#   config = {
#     path = "${path_relative_to_include()}/terraform.tfstate"
#   }
# }

remote_state {
  backend = "s3"

  generate = {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  }

  config = {
    #profile = ""
    #role_arn = ""

    bucket = "terragrunt-poc-2023"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    #key            = "${path_relative_to_include()}/region/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terragrunt-poc"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
    region = "us-west-1"
}
EOF
}