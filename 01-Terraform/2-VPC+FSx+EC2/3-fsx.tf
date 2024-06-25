resource "aws_fsx_windows_file_system" "windows_file_system" {
  depends_on           = [aws_directory_service_directory.fsx_ad]
  deployment_type      = "MULTI_AZ_1"
  storage_type         = "SSD"
  storage_capacity     = 32
  throughput_capacity  = 32
  active_directory_id  = aws_directory_service_directory.fsx_ad.id

  security_group_ids   = [aws_security_group.fsx.id]
  subnet_ids       = module.vpc.private_subnets
  preferred_subnet_id  = module.vpc.private_subnets[0]

  audit_log_configuration {
    file_access_audit_log_level       = "SUCCESS_AND_FAILURE"
    file_share_access_audit_log_level = "SUCCESS_AND_FAILURE"
  }
  # Tags
  tags = {
    Name        = "pocfsx"
    Project     = "Test"
    Environment = "${var.environment}"
  }
}