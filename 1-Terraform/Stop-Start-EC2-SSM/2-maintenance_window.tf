resource "aws_ssm_maintenance_window" "maintenance_window-App1" {
  name     = "maintenance_window-App1"
  description = "Maintenance window to start the group of EC2 instances App1"
  schedule = "cron(0 48 20 ? * * *)" # UTC Time
  duration = 2
  cutoff   = 1
  schedule_timezone = "UTC"
  start_date = "2024-03-22T20:48:00Z" # UTC Time
  #start_date = "2024-03-20T12:00:00+05:30" # India Time
  enabled = true
  allow_unassociated_targets = true
  tags  = {
    Terraform = "True"
    App1      = "True"
  }
}