# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule
resource "aws_autoscaling_schedule" "demo_asg_schedule_stop" {
  scheduled_action_name  = "demo-asg-schedule-stop"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 20 * * 1-5"  # De lunes a viernes a las 20:00 (hora UTC)
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

resource "aws_autoscaling_schedule" "demo_asg_schedule_start" {
  scheduled_action_name  = "demo-asg-schedule-start"
  min_size               = 1
  max_size               = 2
  desired_capacity       = 1
  recurrence             = "0 6 * * 1-5"  # De lunes a viernes a las 06:00 (hora UTC)
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

# resource "aws_autoscaling_schedule" "demo_asg_schedule_stop" {
#   scheduled_action_name  = "demo-asg-schedule_stop"
#   min_size               = 0
#   max_size               = 1
#   desired_capacity       = 0
#   start_time             = "2024-06-20T18:00:00Z"
#   end_time               = "2024-06-20T06:00:00Z"
#   autoscaling_group_name = aws_autoscaling_group.demo.name
# }