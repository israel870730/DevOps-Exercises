# Private Subnet VPC-1
resource "aws_flow_log" "private-subnets-vpc-1" {
  for_each = { for net, subnet in module.vpc-1.private_subnets : net => subnet }
  log_destination      = aws_s3_bucket.vpc-1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = each.value
  tags= {
        Name = "flow_log-private-subnets-vpc-1"
    }
}

# Public Subnet VPC-1
resource "aws_flow_log" "public-subnets-vpc-1" {
  for_each = { for net, subnet in module.vpc-1.public_subnets : net => subnet }
  log_destination      = aws_s3_bucket.vpc-1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = each.value
  tags= {
        Name = "flow_log-public-subnets-vpc-1"
    }
}

# Private Subnet VPC-2
resource "aws_flow_log" "private-subnets-vpc-2" {
  for_each = { for net, subnet in module.vpc-2.private_subnets : net => subnet }
  log_destination      = aws_s3_bucket.vpc-2.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = each.value
  tags= {
        Name = "flow_log-private-subnets-vpc-2"
    }
}

# Public Subnet VPC-2
resource "aws_flow_log" "public-subnets-vpc-2" {
  for_each = { for net, subnet in module.vpc-2.public_subnets : net => subnet }
  log_destination      = aws_s3_bucket.vpc-2.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = each.value
  tags= {
        Name = "flow_log-public-subnets-vpc-2"
    }
}