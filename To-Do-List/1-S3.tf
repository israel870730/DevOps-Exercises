resource "aws_s3_bucket" "to_do_list" {
  bucket = "poc-to-do-list"
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "to_do_list" {
  bucket = aws_s3_bucket.to_do_list.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "to_do_list_policy" {
  bucket = aws_s3_bucket.to_do_list.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.to_do_list.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "to_do_list_versioning" {
  bucket = aws_s3_bucket.to_do_list.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "frontend_files" {
  for_each = fileset("${path.module}/frontend", "**")

  bucket = aws_s3_bucket.to_do_list.bucket
  key    = each.value
  source = "${path.module}/frontend/${each.value}"
  acl    = "public-read"
}
