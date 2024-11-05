######
# Autoscaling group
######
resource "aws_autoscaling_group" "demo" {
  name                      = "Demo-ASG"
  vpc_zone_identifier = module.vpc.private_subnets

  desired_capacity   = 3
  min_size           = 2
  max_size           = 5

  launch_template {
    id      = aws_launch_template.demo_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Demo"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "POC"
    propagate_at_launch = true
  }

}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.demo.id
  lb_target_group_arn    = aws_lb_target_group.demo.arn
}
