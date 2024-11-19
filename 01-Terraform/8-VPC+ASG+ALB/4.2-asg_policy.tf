#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm

############################################
# Policy and cloudwatch alarm for up
############################################
resource "aws_autoscaling_policy" "asg_policy_up" {
  name = "asg_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name = "asg_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  #comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"
dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [aws_autoscaling_policy.asg_policy_up.arn, aws_sns_topic.topic_sns.arn]
}

############################################
# Policy and cloudwatch alarm for down
############################################
resource "aws_autoscaling_policy" "asg_policy_down" {
  name = "asg_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  autoscaling_group_name = aws_autoscaling_group.demo.name
}

resource "aws_cloudwatch_metric_alarm" "asg_low_cpu" {
  alarm_name = "asg_low_cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  #comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "30"
dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demo.name
  }
alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [aws_autoscaling_policy.asg_policy_down.arn, aws_sns_topic.topic_sns.arn]
}