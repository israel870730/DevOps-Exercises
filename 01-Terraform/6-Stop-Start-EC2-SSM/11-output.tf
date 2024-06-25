output "cloud_custodian_role_arn" {
  value = aws_iam_role.cloud_custodian_role.arn
}

output "ec2_private_ip" {
  #value = aws_instance.demo_cloud_custodian[0].private_ip
  value = [for instance in aws_instance.demo_cloud_custodian : instance.private_ip]
}
