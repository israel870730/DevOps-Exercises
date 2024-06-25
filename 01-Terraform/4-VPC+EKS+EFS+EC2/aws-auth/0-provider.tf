terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}

provider "aws" {
  region = local.region
  assume_role {
    role_arn = var.terraformrole
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_info.endpoint
  #cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_info.certificate_authority)
  cluster_ca_certificate = base64decode(lookup(element(data.aws_eks_cluster.eks_info.certificate_authority, 0), "data", ""))
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_info.name]
  }
}