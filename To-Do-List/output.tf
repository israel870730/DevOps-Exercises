output "s3_bucket_website_url" {
  value = aws_s3_bucket_website_configuration.to_do_list.website_endpoint
}
