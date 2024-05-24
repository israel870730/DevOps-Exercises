resource "aws_efs_file_system" "demo_efs" {
  creation_token = "demo"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  # lifecycle_policy {
  #   transition_to_ia = "AFTER_30_DAYS"
  # }

  tags = {
    Name = "demo"
  }
}

resource "aws_efs_mount_target" "zone" {
  for_each = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
  file_system_id  = aws_efs_file_system.demo_efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs.id]
}