terraform {
  required_version = ">= 1.0"
}

locals {
  common_tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.12.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = var.vpc_id == "" ? data.aws_vpc.selected.id : var.vpc_id
  subnet_ids                      = var.subnets
  enable_irsa                     = var.enable_irsa

  # Default for all node groups
  #Aqui defino los valores predeterminado que van a tener todos los "eks_managed_node_groups"
  eks_managed_node_group_defaults = {
    desired_size = 2
    min_size     = 2
    max_size     = 5

    ami_id = "ami-0e3758acc10746561"
    enable_bootstrap_user_data = true

    #capacity_type    = "SPOT"       # default spot instance
    eni_delete       = true         # delete eni on termination
    #key_name         = local.key    # default ssh keypair for nodes
    ebs_optimized    = true         # ebs optimized instance
    ami_type         = "AL2_x86_64" # default ami type for nodes
    create_launch_template  = true
    enable_monitoring       = true
    update_default_version  = false  # set new LT ver as default

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 25
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          #encrypted             = true
          #kms_key_id            = module.ebs_kms_key.key_arn
          delete_on_termination = true
        }
      }
    }

    # Subnets to use (Recommended: Private Subnets)
    #subnets          = data.aws_subnet_ids.default_public.ids

    # user data for LT
    pre_userdata = ""

    update_config = {
      max_unavailable_percentage = 10 # or set `max_unavailable`
    }
  }
  
  eks_managed_node_groups         = var.eks_managed_node_groups
  manage_aws_auth_configmap       = var.manage_aws_auth_configmap
  aws_auth_roles                  = [ for aws_auth_role in var.aws_auth_roles : aws_auth_role ]
  aws_auth_users                  = [ for aws_auth_user in var.aws_auth_users : aws_auth_user ]
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  #tags                            = var.tags
  tags                   = merge(var.tags, local.common_tags)
}
