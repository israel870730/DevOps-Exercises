#Bucket principal
resource "aws_s3_bucket" "source_bucket" {
  bucket = local.bucket_source
  tags = local.tags
}

# Este otro bucket es necesario para habilitar "aws_s3_bucket_replication_configuration"
resource "aws_s3_bucket" "destination_bucket" {
  bucket = local.bucket_destination
  tags = local.tags
}

# Bucket donde vamos a salvar los log cuando se habilite el logging del bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = local.bucket_log
  tags = local.tags
}

# Habilitando el versionado
resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "destination_bucket_versioning" {
  bucket = aws_s3_bucket.destination_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Habilitando la opcion "Server access logging"
resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket = aws_s3_bucket.source_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# Usá esta política para que S3 pueda escribir logs directamente al bucket
resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowS3Logging",
        Effect    = "Allow",
        Principal = {
          Service = "logging.s3.amazonaws.com" # El Principal debe ser "logging.s3.amazonaws.com".
        },
        Action = [
          "s3:PutObject"
        ],
        Resource = "${aws_s3_bucket.log_bucket.arn}/log/*" # El Resource debe coincidir con el target_prefix que definiste en aws_s3_bucket_logging (ej. "log/*").
      }
    ]
  })
}

# Regla de ciclo de vida pra todo el bucket "source"
resource "aws_s3_bucket_lifecycle_configuration" "source_lifecycle" {
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

# Notificamos el uso del bucket "source" usando un topic de SNS
resource "aws_s3_bucket_notification" "source_notification" {
  bucket = aws_s3_bucket.source_bucket.id
  depends_on = [aws_sns_topic_policy.allow_s3_publish]

  topic {
    topic_arn     = aws_sns_topic.topic_sns_s3.arn
    events        = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*", "s3:Replication:*", "s3:ObjectRestore:*", "s3:LifecycleExpiration:*"]
    filter_suffix = ""
  }
}

# Habilitando la opcion replication del bucket "source_bucket" al bucket "destination_bucket"
resource "aws_s3_bucket_replication_configuration" "source_replication" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source_bucket_versioning]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id = "examplerule"
    status = "Enabled"

    delete_marker_replication {
      status = "Disabled"
    }

    filter {
      prefix = "" # Si querés que se repliquen todos los objetos, simplemente usá un filtro vacío
    }
    
    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"
    }
  }
}
