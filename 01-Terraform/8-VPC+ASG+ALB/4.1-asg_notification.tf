# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [
    aws_autoscaling_group.demo.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.topic_sns_ssm.arn
}
