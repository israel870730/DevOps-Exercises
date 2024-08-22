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

resource "aws_efs_mount_target" "zone1" {
  #for_each = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
  file_system_id  = aws_efs_file_system.demo_efs.id
  #subnet_id       = each.value
  subnet_id       = "subnet-0c3d1ae5222d8d337"
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "zone2" {
  #for_each = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
  file_system_id  = aws_efs_file_system.demo_efs.id
  #subnet_id       = each.value
  subnet_id       = "subnet-0f8c74d7623b6a570"
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "zone3" {
  #for_each = { for idx, subnet in module.vpc.private_subnets : idx => subnet }
  file_system_id  = aws_efs_file_system.demo_efs.id
  #subnet_id       = each.value
  subnet_id       = "subnet-083ecf340b68f5c86"
  security_groups = [aws_security_group.efs.id]
}