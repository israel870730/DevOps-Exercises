provider "aws" {
  region = local.region
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}

locals {
  region      = "us-east-1"
  role_name     = "TerraformRole-Eks"
}

resource "aws_iam_role" "terraform_role" {
  name               = local.role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::012345678901:user/poc",
					  "arn:aws:iam::012345678901:root", # To change
            #"arn:aws:iam::012345678901:assumed-role/TerraformRole-Eks/demo" # Descomentar despues que se cree el rol y ejecutar terraform otra vez
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attachment_policy" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
