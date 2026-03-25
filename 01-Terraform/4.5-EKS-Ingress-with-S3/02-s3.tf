data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}

#Bucket
resource "aws_s3_bucket" "source_bucket" {
  bucket = local.bucket_source
  tags = local.tags
}

# Habilitando el versionado
resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "source_bucket_policy" {
  bucket = aws_s3_bucket.source_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.aws_elb_service_account.main.arn
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${local.bucket_source}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${local.bucket_source}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "arn:aws:s3:::${local.bucket_source}"
      }
    ]
  })
}

# Regla de ciclo de vida pra todo el bucket "source"
resource "aws_s3_bucket_lifecycle_configuration" "source_bucket_lifecycle" {
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id = "rule-1"
    filter {
      prefix = ""
    }
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

# Usá esta política para que S3 pueda escribir logs directamente al bucket
# resource "aws_s3_bucket_policy" "source_bucket_policy" {
#   bucket = aws_s3_bucket.source_bucket.id
#   policy = jsonencode(
#     {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::652711504416:root" # Europa

#             },
#             "Action": "s3:PutObject",
#             #"Resource": "arn:aws:s3:::poc-eu-west-2-demo-eks-pod-log-alb1/*"
#             "Resource": "arn:aws:s3:::${local.bucket_source}/*"

#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "elasticloadbalancing.amazonaws.com"
#             },
#             "Action": "s3:PutObject",
#             #"Resource": "arn:aws:s3:::poc-eu-west-2-demo-eks-pod-log-alb1/poc-alb-accesslogs/AWSLogs/370389955891/*"
#             "Resource": "arn:aws:s3:::${local.bucket_source}/poc-alb-accesslogs/AWSLogs/370389955891/*"
#         }
#     ]
#   })
# }
