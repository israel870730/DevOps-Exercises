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
    security_group_ids = [aws_security_group.sg_sftpefs.id]
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

resource "aws_route53_record" "sftpefs_dns_alias" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "sftpefs.example.com"
  type    = "CNAME"
  ttl     = 300
  
  # En este registro sftpefs.example.com o ponemos el endpoint de la vpc para transfer family ejemplo 
  # "vpce-03f3bac2322d9db89-o8onpgb4.vpce-svc-04a46ad06b83edd48.us-west-1.vpce.amazonaws.com."
  # o ponemos los ip que estan en la configuracion del endpoint "10.0.10.185"
  records = [data.aws_vpc_endpoint.transfer_family_endpoint.dns_entry[0].dns_name]
}


# Este SG para el endpoint del SFTP
resource "aws_security_group" "sg_sftpefs" {
  name        = "sg_sftpefs"
  description = "sg_sftpefs"
  vpc_id = module.vpc.vpc_id

  ingress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_sftpefs"
  }
}