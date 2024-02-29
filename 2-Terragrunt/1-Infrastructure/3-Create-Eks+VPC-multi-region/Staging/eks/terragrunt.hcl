terraform {
  source = "../../../../Terraform-Modules/compute/eks/"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path              = find_in_parent_folders("env.hcl")
  expose            = true
  merge_strategy    = "no_merge"
}

inputs = {
  region                          = include.env.locals.region
  cluster_name                    = include.env.locals.cluster_name
  cluster_version                 = "1.26"
  environment                     = include.env.locals.env

  vpc_id                          = dependency.vpc.outputs.vpc_id
  subnets                         = dependency.vpc.outputs.private_subnets

  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true

  project_name                    = include.env.locals.project_name

  eks_managed_node_groups = {
    # default_node_group = {
    #   # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
    #   # so we need to disable it to use the default template provided by the AWS EKS managed node group service
    #   use_custom_launch_template = false
    #   disk_size = 50
    # }

    custom_ami = {
        #ami_type = "AL2_ARM_64"
        # Current default AMI used by managed node groups - pseudo "custom"
        ami_id = "ami-0d363b68fd5fa8bde"

        # This will ensure the bootstrap user data is used to join the node
        # By default, EKS managed node groups will not append bootstrap script;
        # this adds it back in using the default template provided by the module
        # Note: this assumes the AMI provided is an EKS optimized AMI derivative
        enable_bootstrap_user_data = true

        instance_types = ["t3.medium"]
    }

    complete = {
        name            = "complete-eks-mng"
        use_name_prefix = true

        min_size     = 1
        max_size     = 7
        desired_size = 1

        ami_id                     = "ami-0e6ed147161a0dbba"
        enable_bootstrap_user_data = true

        pre_bootstrap_user_data = <<-EOT
          export FOO=bar
        EOT

        post_bootstrap_user_data = <<-EOT
          echo "you are free little kubelet!"
        EOT

        capacity_type        = "SPOT"
        force_update_version = true
        instance_types       = ["t3.large", "t3.medium", "t3.small", "t3.xlarge"]
        labels = {
          GithubRepo = "terraform-aws-eks"
          GithubOrg  = "terraform-aws-modules"
        }
    }
  }

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::114712064551:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_AWSAdministratorAccess_e1c02011dbc6c63b"
      username = "AWSReservedSSO_AWSAdministratorAccess_e1c02011dbc6c63b/israel.garcia"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::114712064551:user/israel.garcia@verifone.com"
      username = "israel.garcia"
      groups   = ["system:masters"]
    },
  ]

  tags = {
    Service  = "Greenbox"
    Type     = "Application"
    App_Name = "Kubernetes"
    Country  = "UK"
    Region   = "EMEA"
  }
}

dependency "vpc" {
  config_path = "../vpc"
}