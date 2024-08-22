resource "aws_s3_bucket" "demo" {
  bucket = "demo-aws-transfer-family-20240820"

  tags = {
    Name = "demo-aws-transfer-family-20240820"
  }
}