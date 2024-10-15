# Cada TARGUET tiene que ir asociado a una ventana de mantenimiento por lo que en este caso tendremos 2
# y tambien le pasamos el grupo de instancia con las que vamos a trabajar
resource "aws_ssm_maintenance_window_target" "maintenance_window_target_stop_App1" {
  window_id     = aws_ssm_maintenance_window.maintenance_window_stop_App1.id
  name          = "maintenance_window_target_stop_App1"
  description   = "This is a maintenance window target to STOP instances group APP1"
  resource_type = "RESOURCE_GROUP"

  targets {
    key    = "resource-groups:Name"
    values = [aws_resourcegroups_group.resourcegroups_App1.name]
  }
  
  targets {
    key    = "resource-groups:ResourceTypeFilters"
    values = ["AWS::EC2::Instance"]
  }
}

resource "aws_ssm_maintenance_window_target" "maintenance_window_target_start_App1" {
  window_id     = aws_ssm_maintenance_window.maintenance_window_start_App1.id
  name          = "maintenance_window_target_start_App1"
  description   = "This is a maintenance window target to START instances group APP1"
  resource_type = "RESOURCE_GROUP"

  targets {
    key    = "resource-groups:Name"
    values = [aws_resourcegroups_group.resourcegroups_App1.name]
  }
  
  targets {
    key    = "resource-groups:ResourceTypeFilters"
    values = ["AWS::EC2::Instance"]
  }
}