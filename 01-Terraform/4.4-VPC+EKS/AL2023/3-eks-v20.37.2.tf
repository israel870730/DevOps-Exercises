module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "20.37.2"

  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  cluster_endpoint_private_access          = var.cluster_endpoint_private_access 
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  enable_irsa                              = var.enable_irsa
  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true
  cluster_enabled_log_types                = var.cluster_enabled_log_types
  cluster_service_ipv4_cidr                = var.service_cidr_block
  cloudwatch_log_group_retention_in_days   = var.cloudwatch_log_group_retention_in_days
  # Cifrado de secretos (en reposo) con KMS administrado por este módulo
  cluster_encryption_config                = { resources = ["secrets"] }
  create_kms_key                           = true

  # Add-ons administrados por EKS
  cluster_addons = {
    # VPC CNI primero, así los nodos ya nacen con la config correcta
    vpc-cni = {
      most_recent    = true
      before_compute = true
      # Prefix delegation para más IPs/Pod
      # configuration_values = jsonencode({
      #   env = {
      #     ENABLE_PREFIX_DELEGATION = "true"
      #     WARM_PREFIX_TARGET       = "1"
      #   }
      # })
    }

    # Core
    coredns    = { 
      most_recent = true
      #addon_version    = "v1.11.4-eksbuild.22"
      #resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = { most_recent = true }
  }
  
  eks_managed_node_groups = {
    # ng-custom = {
    #   ami_type = "AL2023_x86_64_STANDARD" # Esto es para AL2023
    #   #ami_type = "AL2_x86_64" # Esto es para Al2
    #   name     = "custom-demo-al2023"
    #   #capacity_type              = "SPOT"
    #   #ami_id   = data.aws_ami.eks_default_al2023.image_id
    #   #ami_id   = "ami-0d9fd0868229e5675" # AMI creada por mi y funciona bien
    #   ami_id   = "ami-0b85c912d9f61cf61" # amazon-eks-node-al2023-x86_64-standard-1.33-v20251007
    #   ami_ssm_parameter = null

    #   # Evita que intente resolver AMI por SSM

    #   instance_types = var.instance_types
    #   min_size       = 1
    #   max_size       = 3
    #   desired_size   = 1

    #   # AL2023 usa nodeadm: proveemos user-data (multipart con application/node.eks.aws)
    #   enable_bootstrap_user_data = true
    #   #user_data_template_path    = "${path.module}/userdata/al2023-nodeadm.tftpl"
    #   enable_monitoring       = true


    #   update_config = {
    #     max_unavailable_percentage = 33
    #   }

    #   tags = {
    #     "k8s.io/cluster-autoscaler/enabled"             = "true"
    #     "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    #     "aws-node-termination-handler/managed" = "true"
    #   }

    #   iam_role_additional_policies = {
    #     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    #   }
    # },
    poc-gpu = {
      ami_type  = "AL2023_x86_64_NVIDIA"
      name     = "gpu-demo-al2023"
      #capacity_type              = "SPOT"
      #ami_id   = ""

      # Evita que intente resolver AMI por SSM
      #ami_ssm_parameter = null

      #instance_types = ["g5.xlarge", "g6.xlarge", "g4dn.xlarge", "g4ad.xlarge", "g5.2xlarge"]
      instance_types = ["g6.xlarge"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1

      # AL2023 usa nodeadm: proveemos user-data (multipart con application/node.eks.aws)
      enable_bootstrap_user_data = true
      #user_data_template_path    = "${path.module}/userdata/al2023-nodeadm.tftpl"
      enable_monitoring       = true


      # update_config = {
      #   max_unavailable_percentage = 33
      # }

      labels = {
        "node.type" = "extract-worker-gpu"
        "k8s.amazonaws.com/accelerator" = "nvidia-gpu"
      }
      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
        "aws-node-termination-handler/managed" = "true"
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
#     description = "aws-load-balancer-controller Helm chart deployment configuration"
#     values = [templatefile("${path.module}/values/aws_lb_controller_values.yaml", {
#       cluster_name = var.cluster_name
#       tags_values = indent(2, yamlencode(local.tags))
#     })]
#   }

#   # --- NVIDIA Device Plugin ---
#   # enable_nvidia_device_plugin = true
#   # nvidia_device_plugin_helm_config = {
#   #   # El módulo despliega el chart oficial de NVIDIA
#   #   name              = "nvidia-device-plugin"
#   #   namespace         = "kube-system"
#   #   description       = "nvidia-device-plugin Helm chart deployment configuration"
#   #   #create_namespace  = false
#   #   #repository        = "https://nvidia.github.io/k8s-device-plugin"
#   #   #chart             = "nvidia-device-plugin"
#   #   # version          = "0.17.4"   # Opcional: fija versión de chart

#   #   # Values para aislarlo a tus nodos GPU:
#   #   values = [<<-YAML
#   #     tolerations:
#   #       - key: "nvidia.com/gpu"
#   #         operator: "Exists"
#   #         effect: "NoSchedule"
#   #     nodeSelector:
#   #       node.type: "extract-worker-gpu"
#   #   YAML
#   #   ]
#   # }

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

data "aws_ami" "eks_default_al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    #amazon-eks-node-al2023-x86_64-standard-1.31-v20250212
    values = ["amazon-eks-node-al2023-x86_64-standard-${var.cluster_version}-v*"]
  }
}

########################################
# nvidia-device-plugin
########################################
# resource "kubernetes_manifest" "nvidia_device_plugin" {
#   provider = kubernetes.eks
#   manifest = yamldecode(file("${path.module}/values/nvidia-device-plugin.yml"))

#   # Server-Side Apply config (bloque, no argumentos sueltos)
#   //¿Qué es field_manager?
#   //Cuando usas kubernetes_manifest, el provider aplica los recursos con el mecanismo de Server-Side Apply (SSA) de Kubernetes.
#   //Con SSA, cada “actor” (kubectl, Terraform, ArgoCD, etc.) puede ser identificado como un field manager: el que “posee” ciertas claves/atributos del objeto.
#   field_manager {
#     name            = "terraform-nvdp" // Ese es el identificador que le damos a Terraform en el objeto.
#     force_conflicts = true //“Si hay conflicto de ownership, fuerza y sobreescribe con mis valores”.
#   }

#   depends_on = [module.eks]
# }
