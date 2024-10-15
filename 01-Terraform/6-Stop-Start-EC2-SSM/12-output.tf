output "ssm_role_arn" {
  value = aws_iam_role.Start_Stop_EC2_SSM.arn
}

output "ec2_private_ip" {
  #value = aws_instance.demo_cloud_custodian[0].private_ip
  value = [for instance in aws_instance.demo_ssm : instance.private_ip]
}
