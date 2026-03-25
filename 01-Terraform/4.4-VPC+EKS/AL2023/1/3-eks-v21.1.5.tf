module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version = "21.1.5"

  name                    = var.cluster_name
  kubernetes_version                 = var.cluster_version

  endpoint_private_access = var.cluster_endpoint_private_access 
  endpoint_public_access  = var.cluster_endpoint_public_access
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  enable_irsa                     = var.enable_irsa
  # Access Entries (reemplaza aws-auth clásico)
  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  # Cifrado de secretos (en reposo) con KMS administrado por este módulo
  encryption_config = { resources = ["secrets"] }
  create_kms_key            = true

  enabled_log_types       = var.cluster_enabled_log_types
  tags                            = merge(var.tags, local.common_tags)

  # Add-ons administrados por EKS
  addons = {
    # VPC CNI primero, así los nodos ya nacen con la config correcta
    vpc-cni = {
      most_recent    = true
      before_compute = true
      # Prefix delegation para más IPs/Pod
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }

    # Core
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
  }

  # Managed Node Group con AMI personalizada (AL2023)
  eks_managed_node_groups = {
    ng-custom = {
      ami_type       = "AL2023_x86_64_STANDARD"
      ami_id         = data.aws_ami.eks_default_al2023.image_id   # Tu AMI (derivada de AL2023 EKS-optimized)
      instance_types = var.instance_types
      enable_monitoring       = true

      min_size       = 2
      max_size       = 8
      desired_size   = 3

      disk_size = 80

      # El módulo generará el user-data correcto (nodeadm para AL2023)
      enable_bootstrap_user_data = true

      update_config = {
        max_unavailable_percentage = 33
      }

      # Etiquetas útiles si usas Cluster Autoscaler (opcional)
      tags = {
        "k8s.io/cluster-autoscaler/enabled"                     = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}"         = "owned"
      }
      iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    }
  }
  
  # Ejemplo de como agregar una regla al SG del cluster
  # cluster_security_group_additional_rules  = {
  #   egress_jenkins = {
  #     type             = "ingress"
  #     from_port        = 443
  #     to_port          = 443
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     description      = "Allow all from Jenkins"
  #   }
  # }

  # Ejemplo de como agregar una regla al SG los worker node
  # node_security_group_additional_rules = {
  #   ingress_allow_access_from_control_plane = {
  #     type                          = "ingress"
  #     protocol                      = "-1"
  #     from_port                     = 0
  #     to_port                       = 0
  #     source_cluster_security_group = true
  #     description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
  #   }
  # }
}

data "aws_ami" "eks_default_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    #amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
    values = ["amazon-eks-node-al2023-x86_64-standard-${var.cluster_version}-v*"]
  }
}

#Terraform (AWS provider ≥ v5.44 / v6.x)
resource "aws_eks_access_entry" "devops_role" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::012345678901:role/aws-reserved/sso.amazonaws.com/eu-west-2/AWSReservedSSO_AWSAdministratorAccess_e1c02011dbc6c63b"
  type          = "STANDARD" # permite asociar policies
}

resource "aws_eks_access_policy_association" "devops_role_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.devops_role.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"   # o "namespace"
    # namespaces = ["payments","core"]  # si fuera scope por namespace
  }
}
