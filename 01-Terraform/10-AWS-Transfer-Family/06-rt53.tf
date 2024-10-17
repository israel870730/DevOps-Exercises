resource "aws_route53_zone" "private" {
  name = "example.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}
########################################################################
# Aqui definimos los registros DNS que van hacer usados por el SFTP
########################################################################
resource "aws_route53_record" "sftp_dns_alias" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "sftps3.example.com"
  type    = "CNAME"
  ttl     = 300
  
  records = [aws_transfer_server.sftp_transfer_server.endpoint]
}
############################################################################################################
# Cuando se crea todo la primera ves es normal que este recuros falle al tratar de ser creado pq quizas 
# el endpoint del servicio transfer family no este creado, de ser asi entonces volver a ejecutar terraform
############################################################################################################
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
