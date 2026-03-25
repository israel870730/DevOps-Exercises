output "source_bucket_id" {
  description = "ID of the source S3 bucket"
  value       = aws_s3_bucket.source_bucket.bucket
}

output "destination_bucket_id" {
  description = "ID of the destination S3 bucket"
  value       = aws_s3_bucket.destination_bucket.id
}

output "log_bucket_id" {
  description = "ID of the log S3 bucket"
  value       = aws_s3_bucket.log_bucket.id
}
