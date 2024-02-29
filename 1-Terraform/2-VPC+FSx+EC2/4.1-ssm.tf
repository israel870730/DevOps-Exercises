resource "aws_ssm_document" "ad-join-domain" {
  name          = "ssm_document_name"
  document_type = "Command"
  content = jsonencode(
    {
      "schemaVersion" = "2.2"
      "description"   = "aws:domainJoin"
      "mainSteps" = [
        {
          "action" = "aws:domainJoin",
          "name"   = "domainJoin",
          "inputs" = {
            "directoryId"    = aws_directory_service_directory.fsx_ad.id,
            "directoryName"  = aws_directory_service_directory.fsx_ad.name,
            "dnsIpAddresses" = sort(aws_directory_service_directory.fsx_ad.dns_ip_addresses)
          }
        }
      ]
    }
  )
}

resource "aws_ssm_association" "windows_server" {
  count = 2
  name = aws_ssm_document.ad-join-domain.name
  targets {
    key    = "InstanceIds"
    values = [aws_instance.fsx_instance[count.index].id]
  }
}