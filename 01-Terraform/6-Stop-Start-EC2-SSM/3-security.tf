resource "aws_security_group" "demo_ssm" {
  name        = "demo-ssm"
  description = "demo_ssm"
  vpc_id = module.vpc.vpc_id
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 22
     to_port = 22
     protocol = "tcp"
   }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "demo_ssm"
  }
}