module "eks" {
    source                          = "terraform-aws-modules/eks/aws"
    version                         = "20.33.1"

    cluster_name                    = var.cluster_name
    cluster_version                 = var.cluster_version

    cluster_endpoint_private_access = var.cluster_endpoint_private_access 
    cluster_endpoint_public_access  = var.cluster_endpoint_public_access
    vpc_id                          = module.vpc.vpc_id
    subnet_ids                      = module.vpc.private_subnets
    enable_irsa                     = var.enable_irsa
    authentication_mode                      = "API_AND_CONFIG_MAP"
    enable_cluster_creator_admin_permissions = true
    cluster_enabled_log_types       = var.cluster_enabled_log_types


    # Cifrado de secretos (en reposo) con KMS administrado por este módulo
    cluster_encryption_config = { resources = ["secrets"] }
    create_kms_key            = true

    # Add-ons administrados por EKS
    cluster_addons = {
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

    # ===== Managed Node Group con AMI personalizada AL2023 =====
  eks_managed_node_groups = {
    ng-custom = {
      ami_type = "AL2023_x86_64_STANDARD"
      ami_id   = data.aws_ami.eks_default_al2023.image_id

      # Evita que intente resolver AMI por SSM
      ami_ssm_parameter = null

      instance_types = var.instance_types
      min_size       = 2
      max_size       = 8
      desired_size   = 3
      disk_size      = 80

      # AL2023 usa nodeadm: proveemos user-data (multipart con application/node.eks.aws)
      enable_bootstrap_user_data = true
      #user_data_template_path    = "${path.module}/userdata/al2023-nodeadm.tftpl"
      enable_monitoring       = true


      update_config = {
        max_unavailable_percentage = 33
      }

      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }

      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }
    
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

# eks kubernetes addons
# https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/v4.32.1
module "eks_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
  depends_on = [null_resource.kubeconfig]

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

  enable_cluster_autoscaler = true

  enable_aws_efs_csi_driver      = true
  aws_efs_csi_driver_helm_config = {
    name        = "aws-efs-csi-driver"
    namespace   = "kube-system"
    description = "The AWS EFS CSI driver Helm chart deployment configuration"
  }


  enable_aws_cloudwatch_metrics      = true
  aws_cloudwatch_metrics_helm_config = {
    name        = "aws-cloudwatch-metrics"
    namespace   = "kube-system"
    description = "The AWS CloudWatch Metrics Helm chart deployment configuration"
  }

  enable_metrics_server      = true
  metrics_server_helm_config = {
    name        = "metrics-server"
    namespace   = "kube-system"
    description = "Metrics Server Helm chart deployment configuration"
  }

  enable_aws_load_balancer_controller      = true
  aws_load_balancer_controller_helm_config = {
    name       = "aws-load-balancer-controller"
    namespace  = "kube-system"
    escription = "aws-load-balancer-controller Helm chart deployment configuration"
  }

  tags = local.tags
}

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


data "aws_ami" "eks_default_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
      name   = "name"
      #amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
      values = ["amazon-eks-node-al2023-x86_64-standard-${var.cluster_version}-v*"]
    }
}