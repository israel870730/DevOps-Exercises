output "eks_cluster_id" {
  value = module.eks_blueprints.eks_cluster_id
}

#-------------------------------
# EKS Cluster Module Outputs
#-------------------------------
output "eks_cluster_arn" {
  description = "Amazon EKS Cluster Name"
  value       = module.eks_blueprints.eks_cluster_arn
}

output "eks_cluster_name" {
  description = "Amazon EKS Cluster Name"
  value       = module.eks_blueprints.eks_cluster_id
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_blueprints.eks_cluster_certificate_authority_data
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks_blueprints.eks_cluster_endpoint
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = module.eks_blueprints.oidc_provider
}

# output "eks_oidc_provider_arn" {
#   description = "The ARN of the OIDC Provider if `enable_irsa = true`."
#   value       = module.eks_blueprints.oidc_provider_arn
# }

output "eks_cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = module.eks_blueprints.eks_cluster_version
}

#-------------------------------
# Cluster Security Group
#-------------------------------
output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks_blueprints.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  description = "EKS Control Plane Security Group ID"
  value       = module.eks_blueprints.cluster_security_group_id
}

output "cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = module.eks_blueprints.cluster_security_group_arn
}

#-------------------------------
# EKS Worker Security Group
#-------------------------------
output "worker_node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the worker node shared security group"
  value       = module.eks_blueprints.worker_node_security_group_arn
}

output "worker_node_security_group_id" {
  description = "ID of the worker node shared security group"
  value       = module.eks_blueprints.worker_node_security_group_id
}

output "self_managed_node_group_iam_instance_profile_id" {
  description = "IAM instance profile id of managed node groups"
  value       = module.eks_blueprints.self_managed_node_group_iam_instance_profile_id
}

################################################################################
# Another
################################################################################
output "configure_kubectl" {
  description = "Configure kubectl using AWS cli"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}"
}

output "efs_id" {
  description = "EFS ID"
  value = aws_efs_file_system.demo_efs.id
}

output "ec2_id" {
  description = "EC2 ID"
  value = aws_instance.jumbox.id
}
