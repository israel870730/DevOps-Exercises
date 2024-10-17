resource "aws_transfer_server" "sftp_transfer_server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
  protocols              = ["SFTP"] # Especificamos el protocolo SFTP
  domain                 = "S3"     # Especificamos S3 como el sistema de almacenamiento
  security_policy_name   = "TransferSecurityPolicy-2024-01"
  post_authentication_login_banner = "Bienvenido al SFTP usando S3"
  logging_role  = aws_iam_role.iam_for_transfer.arn
  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer.arn}:*"
  ]
  tags = {
    Name = "SFTP-S3-Server"
  }
}

resource "aws_transfer_tag" "hostname" {
  resource_arn = aws_transfer_server.sftp_transfer_server.arn
  key          = "aws:transfer:customHostname"
  value        = "sftps3.example.com"
}

resource "aws_cloudwatch_log_group" "transfer" {
  name_prefix = "transfer_test_"
}

data "aws_iam_policy_document" "transfer_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_for_transfer_"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"]
}