# Aqui vamos a definir un par de ventanas de mantenimiento para cada una de las tareas
# Stop instances
resource "aws_ssm_maintenance_window" "maintenance_window_stop_App1" {
  name     = "maintenance_window_stop_App1"
  description = "Maintenance window to stop the group of EC2 instances App1"
  schedule = "cron(0 40 17 ? * * *)" # UTC Time
  duration = 2
  cutoff   = 1
  schedule_timezone = "UTC"
  #start_date = "2024-10-05:00:00Z" # UTC Time
  #start_date = "2024-10-11T16:00:00-02:00" # Esto "-02:00" significa que estamos usando UTC
  enabled = true
  allow_unassociated_targets = true
}

# Start instances
resource "aws_ssm_maintenance_window" "maintenance_window_start_App1" {
  name     = "maintenance_window_start_App1"
  description = "Maintenance window to start the group of EC2 instances App1"
  schedule = "cron(0 50 17 ? * * *)" # UTC Time
  duration = 2
  cutoff   = 1
  schedule_timezone = "UTC"
  #start_date = "2024-10-05:00:00Z" # UTC Time
  #start_date = "2024-10-11T16:00:00-02:00" # Ajustar
  #start_date = "2024-03-20T12:00:00+05:30" # India Time
  enabled = true
  allow_unassociated_targets = true
}
