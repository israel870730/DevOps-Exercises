module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  #version                         = "19.12.0"
  version                         = "20.33.1"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
 
  enable_irsa                     = var.enable_irsa
  # "enable_cluster_creator_admin_permissions" hace que el creador del clúster (IAM principal que ejecuta Terraform) tenga una entrada de acceso como system:masters, 
  # sin necesidad de estar manualmente en el aws-auth.
  # Sin esta tag cuando cree el cluster no voy a tener acceso al cluster, ya no es como en la otra version del modulo 
  # Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  
  # Agregando estas access_entries ya no es necesario tocar el configmap aws-auth
  # Si usás access_entries, ya no es necesario —ni recomendable— modificar el ConfigMap aws-auth directamente.
  # Desde mediados de 2023, AWS introdujo el nuevo sistema de control de acceso para EKS basado en Access Entries y Access Policies, 
  # y el ConfigMap aws-auth quedó como un mecanismo legacy (heredado).
  # Las AccessEntry de EKS solo soportan:
      #Roles IAM normales
      #Usuarios IAM normales
  # access_entries = {
  #   "eks_admin_1" = {
  #     principal_arn  = "arn:aws:iam::012345678901:role/TerraformRole-Eks"
  #     username = "admin-role"
  #     groups   = ["system:masters"]
  #   }
  # }

  # self_managed_node_group_defaults = {
  #   #ami_type         = "AL2023_x86_64_STANDARD"
  #   enable_bootstrap_user_data = false
  #   enable_monitoring       = true
  #   cloudinit_pre_nodeadm = [
  #     {
  #       content_type = "application/node.eks.aws"
  #       content = <<-EOT
  #         ---
  #         apiVersion: node.eks.aws/v1alpha1
  #         kind: NodeConfig
  #         spec:
  #           cluster:
  #             name: ${module.eks.cluster_name}
  #             apiServerEndpoint: ${module.eks.cluster_endpoint}
  #             certificateAuthority: ${local.cert_base64}
  #             cidr: ${var.service_cidr_block}
  #       EOT
  #     }
  #   ]
  # }

# https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html
  self_managed_node_groups = {
    ami_al2_outposts = {
      enable_bootstrap_user_data = true
      ami_id = "ami-02950cf8593e4fbac" # AL2
      node_group_name = local.ng_name
      instance_type = var.instance_type
      subnet_ids = [aws_subnet.outpost_subnet1.id,aws_subnet.outpost_subnet2.id]
      #subnet_ids = ["subnet-04481123158a3f4d5","subnet-075e5d1e5049613b5"]
      launch_template_os    = "amazonlinux2eks"
      min_size         = var.min_size
      max_size         = var.max_size
      desired_size     = var.desired_size
      enable_monitoring     = true
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_type = "gp2"
            volume_size = 50
            delete_on_termination = true
          }
        }
     ]
    },
    ami_al2023_outposts = {
      enable_bootstrap_user_data = false
      ami_type      = "AL2023_x86_64_STANDARD" # Just for AL2023
      ami_id = "ami-03bb910d8047f299e" # AL2023
      node_group_name = local.ng_name
      instance_type = var.instance_type
      subnet_ids = [aws_subnet.outpost_subnet1.id,aws_subnet.outpost_subnet2.id]
      #subnet_ids = ["subnet-04481123158a3f4d5","subnet-075e5d1e5049613b5"]
      launch_template_os    = "amazonlinux2eks"
      min_size         = var.min_size
      max_size         = var.max_size
      desired_size     = var.desired_size
      enable_monitoring     = true
      # cloudinit_pre_nodeadm = [
      #   {
      #     content_type = "application/node.eks.aws"
      #     content = <<-EOT
      #       ---
      #       apiVersion: node.eks.aws/v1alpha1
      #       kind: NodeConfig
      #       spec:
      #         cluster:
      #           name: ${module.eks.cluster_name}
      #           apiServerEndpoint: ${module.eks.cluster_endpoint}
      #           certificateAuthority: ${local.cert_base64}
      #           cidr: ${var.service_cidr_block}
      #     EOT
      #   }
      # ]
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_type = "gp2"
            volume_size = 50
            delete_on_termination = true
          }
        }
     ]
    }
  }

  #eks_managed_node_groups         = var.eks_managed_node_groups
  cluster_enabled_log_types       = var.cluster_enabled_log_types
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
resource "aws_security_group_rule" "eks_sg_efs" {
  depends_on = [module.eks]
  description = "Allow EFS traffic"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}
# SG of the cluster
resource "aws_security_group_rule" "eks_sg_https" {
  depends_on = [module.eks]
  description = "Allow https traffic to manage the cluster fromthe Jumbox"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.cluster_primary_security_group_id
}
# SG of the cluster
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

# # SG of the worker node
resource "aws_security_group_rule" "node_sg_efs" {
  depends_on = [module.eks]
  description = "Allow EFS traffic"
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
  description = "Allow all traffic from the vpc"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_base_cidr]
  security_group_id = module.eks.node_security_group_id 
}

module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.33.1"
  depends_on = [null_resource.kubeconfig, kubernetes_config_map_v1.aws_auth]
  #manage_aws_auth_configmap = true sobrescribe completamente el ConfigMap aws-auth.
  #Todo lo que no esté definido explícitamente en aws_auth_roles, aws_auth_users, o aws_auth_accounts será eliminado.
  #manage_aws_auth_configmap = true  #Esto fuerza la creación del aws-auth y lo sobreescribe completamente

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::154926407884:role/AWSReservedSSO_AWSAdministratorAccess_891aa128376d5106"
      username = "admin-role"
      groups   = ["system:masters"]
    }
  ]
}

# eks kubernetes addons
# https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/v4.32.1
# module "eks_kubernetes_addons" {
#   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
#   depends_on = [null_resource.kubeconfig]

#   eks_cluster_id       = module.eks.cluster_name
#   eks_cluster_endpoint = module.eks.cluster_endpoint
#   eks_oidc_provider    = module.eks.oidc_provider
#   eks_cluster_version  = module.eks.cluster_version
  
#   enable_cluster_autoscaler = true

#   enable_aws_efs_csi_driver      = true
#   aws_efs_csi_driver_helm_config = {
#     name        = "aws-efs-csi-driver"
#     namespace   = "kube-system"
#     description = "The AWS EFS CSI driver Helm chart deployment configuration"
#   }


#   enable_aws_cloudwatch_metrics      = true
#   aws_cloudwatch_metrics_helm_config = {
#     name        = "aws-cloudwatch-metrics"
#     namespace   = "kube-system"
#     description = "The AWS CloudWatch Metrics Helm chart deployment configuration"
#   }

#   enable_metrics_server      = true
#   metrics_server_helm_config = {
#     name        = "metrics-server"
#     namespace   = "kube-system"
#     description = "Metrics Server Helm chart deployment configuration"
#   }

#   enable_aws_load_balancer_controller      = true
#   aws_load_balancer_controller_helm_config = {
#     name       = "aws-load-balancer-controller"
#     namespace  = "kube-system"
#     escription = "aws-load-balancer-controller Helm chart deployment configuration"
#   }

#   tags = local.tags
# }

resource "null_resource" "kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = <<EOT
      set -e
      echo 'Updating Kube config file'
      # aws sts get-caller-identity
      export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
             $(aws sts assume-role \
                   --role-arn ${var.terraformrole} \
                   --role-session-name Jenkins-EKS-Setup \
                   --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
                   --output text))
      aws sts get-caller-identity
      aws eks wait cluster-active --name '${module.eks.cluster_name}'  --region '${local.region}'
      aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}
    EOT
  }
}

# data "aws_ami" "eks_default" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     #amazon-eks-node-1.30-v20250212
#     values = ["amazon-eks-node-${var.cluster_version}-v*"]
#   }
# }

# data "aws_ami" "eks_default_al2023" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     #amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
#     values = ["amazon-eks-node-al2023-x86_64-standard-${var.cluster_version}-v*"]
#   }
# }

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # data = {
  #   mapRoles = yamlencode([])
  # }
}
