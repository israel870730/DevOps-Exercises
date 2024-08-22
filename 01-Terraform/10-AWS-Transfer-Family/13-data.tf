data "aws_vpc_endpoint" "transfer_family_endpoint" {
  vpc_id    = module.vpc.vpc_id

#   filter {
#     name   = "service-name"
#     values = ["com.amazonaws.${local.region}.transfer.server."]
#   }

  filter {
    name   = "vpc-endpoint-type"
    values = ["Interface"]
  }
}

output "transfer_family_vpc_endpoint_id" {
  description = "transfer_family_vpc_endpoint_id"
  value = data.aws_vpc_endpoint.transfer_family_endpoint.id
}

output "transfer_family_vpc_endpoint_dns_names" {
  description = "transfer_family_vpc_endpoint_dns_names"
  value = data.aws_vpc_endpoint.transfer_family_endpoint.dns_entry[*].dns_name
}
