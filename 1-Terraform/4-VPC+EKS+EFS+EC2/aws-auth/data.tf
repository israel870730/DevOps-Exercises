data "aws_eks_cluster" "eks_info" {
  name = local.cluster_name
}