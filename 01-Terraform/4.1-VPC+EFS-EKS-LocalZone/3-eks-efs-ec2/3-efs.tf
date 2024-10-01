resource "aws_efs_file_system" "demo_efs" {
  creation_token = "demo"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
  tags = {
    Name = "demo"
  }
}

resource "aws_efs_mount_target" "aws_efs" {
  for_each = toset(var.private_subnets)

  file_system_id  = aws_efs_file_system.demo_efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs.id]
}
