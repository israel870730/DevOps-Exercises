resource "aws_s3_bucket" "demo" {
  bucket = local.bucket_name
  tags = {
    Name = local.bucket_name
  }
}