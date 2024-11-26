resource "aws_flow_log" "vpc-1" {
  log_destination      = aws_s3_bucket.vpc-1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc-1.vpc_id
  tags= {
        Name = "flow_log-vpc-1"
    }
}

resource "aws_s3_bucket" "vpc-1" {
  bucket = "${var.environment}-${var.region}-vpc-1"
}

resource "aws_flow_log" "vpc-2" {
  log_destination      = aws_s3_bucket.vpc-2.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc-2.vpc_id
  tags= {
        Name = "flow_log-vpc-2"
    }
}

resource "aws_s3_bucket" "vpc-2" {
  bucket = "${var.environment}-${var.region}-vpc-2"
}
