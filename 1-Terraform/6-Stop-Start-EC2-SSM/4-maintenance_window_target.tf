resource "aws_ssm_maintenance_window_target" "maintenance_window_target-App1" {
  window_id     = aws_ssm_maintenance_window.maintenance_window-App1.id
  name          = "maintenance_window_target-App1"
  description   = "This is a maintenance window target to group APP1"
  resource_type = "RESOURCE_GROUP"

  targets {
    key    = "resource-groups:Name"
    values = [aws_resourcegroups_group.resourcegroups-App1.name]
  }
  
  targets {
    key    = "resource-groups:ResourceTypeFilters"
    values = ["AWS::EC2::Instance"]
  }
}