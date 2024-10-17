resource "aws_transfer_server" "sftpefs_transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "VPC"
  protocols              = ["SFTP"] # Especificamos el protocolo SFTP
  domain                 = "EFS"     # Especificamos S3 como el sistema de almacenamiento
  security_policy_name   = "TransferSecurityPolicy-2024-01"
  post_authentication_login_banner = "Bienvenido al SFTP usando EFS"
  endpoint_details {
    vpc_id             = module.vpc.vpc_id
    subnet_ids         = module.vpc.private_subnets
    # Especificamos el SG para el endpoint
    security_group_ids = [aws_security_group.aws_transfer_server.id]
  }
  logging_role  = aws_iam_role.iam_for_transfer.arn
  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]
  tags = {
    Name = "SFTP-EFS-Server"
  }
}

resource "aws_transfer_tag" "hostname_sftpefs" {
  resource_arn = aws_transfer_server.sftpefs_transfer_server.arn
  key          = "aws:transfer:customHostname"
  value        = "sftpefs.example.com"
}