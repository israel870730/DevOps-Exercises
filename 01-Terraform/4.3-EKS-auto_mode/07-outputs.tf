################################################################################
# Cluster
################################################################################
output "configure_kubectl" {
  description = "Configure kubectl using AWS cli"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}"
}