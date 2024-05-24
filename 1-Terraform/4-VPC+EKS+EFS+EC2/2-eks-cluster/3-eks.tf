module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "19.12.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  enable_irsa                     = var.enable_irsa
  #cluster_service_ipv4_cidr = var.service_cidr_block
  #cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  
  # cluster_addons = {
  #   coredns    = {}
  #   kube-proxy = {}
  #   vpc-cni    = {}
  # }
  # cluster_addons = {
  #   coredns = {
  #     most_recent = true
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  #   vpc-cni = {
  #     most_recent = true
  #   }
  # }

  # Aqui defino los valores predeterminado que van a tener todos los "eks_managed_node_groups"
  eks_managed_node_group_defaults = {
    name             = local.ng_name
    instance_types   = var.instance_types
    #ami_id           = "ami-id"
    ami_id           = data.aws_ami.eks_default.image_id
    min_size         = var.min_size
    max_size         = var.max_size
    desired_size     = var.desired_size
    
    enable_bootstrap_user_data = true
    enable_monitoring       = true
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
  }
  
  eks_managed_node_groups         = var.eks_managed_node_groups
  manage_aws_auth_configmap       = var.manage_aws_auth_configmap
  create_aws_auth_configmap       = var.create_aws_auth_configmap
  cluster_enabled_log_types       = var.cluster_enabled_log_types
  #aws_auth_roles                  = [ for aws_auth_role in var.aws_auth_roles : aws_auth_role ]
  #aws_auth_users                  = [ for aws_auth_user in var.aws_auth_users : aws_auth_user ]
  #tags                            = var.tags
  tags                            = merge(var.tags, local.common_tags)

  # Agregar una regla nueva al SG del los worker node 
  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
}

# SG of the cluster
# Allow traffic from EFS port
resource "aws_security_group_rule" "eks_sg_efs" {
  depends_on = [module.eks]
  description = "Open EFS port in EKS SG"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

# # Allow traffic from 443 port
resource "aws_security_group_rule" "eks_sg_https" {
  depends_on = [module.eks]
  description = "Allow https traffic from all the vpc"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

# Allow all traffic
resource "aws_security_group_rule" "eks_allow_all_from_vpc" {
  depends_on = [module.eks]
  description = "Allow all traffic from the vpc"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}

# SG of the worker node
resource "aws_security_group_rule" "node_sg_efs" {
  depends_on = [module.eks]
  description = "Allow traffic from EFS"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.node_security_group_id 
}

# SG of the worker node -  Allow all 
resource "aws_security_group_rule" "node_sg_allow_all" {
  depends_on = [module.eks]
  description = "Allow traffic from EFS"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.node_security_group_id 
}

# # Adjuntamos la policy "AmazonSSMFullAccess" para poder acceder a los worker node desde el SSM
# resource "aws_iam_policy_attachment" "attach_amazon_ssm_full_access" {
#   count      = length(keys(module.eks.eks_managed_node_groups))
#   name       = "attach_amazon_ssm_full_access_${keys(module.eks.eks_managed_node_groups)[count.index]}"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  
#   # Accede al nombre del rol IAM de cada grupo de nodos y adjunta la política
#   roles = [
#     module.eks.eks_managed_node_groups[keys(module.eks.eks_managed_node_groups)[count.index]].iam_role_name
#   ]
# }

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }
}
