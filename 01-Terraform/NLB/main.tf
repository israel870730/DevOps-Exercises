# NLB
resource "aws_lb" "nlb" {
  name               = "nlb-greenbox"
  internal           = false
  load_balancer_type = "network"
  subnets            = local.subnet_ids

  enable_deletion_protection = false

  tags = local.tags
}

# Target Group
resource "aws_lb_target_group" "nlb_tg" {
  name        = "greenbox-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = local.vpc_id
  target_type = "instance"

  tags = local.tags
}

# Listener
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

# Security Group para permitir tráfico en puerto 80
resource "aws_security_group" "nlb_ec2_sg" {
  name        = "greenbox-nlb-sg"
  description = "Allow HTTP"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

# Crear EC2
resource "aws_instance" "greenbox" {
  count         = 2
  ami           = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2023 (ARM64), cambiar si usas x86_64
  instance_type = "t3.medium"
  subnet_id     = element(local.subnet_ids, count.index % length(local.subnet_ids))
  vpc_security_group_ids = [aws_security_group.nlb_ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Set the hostname
              hostnamectl set-hostname ${each.value.instance_name}.idm.vcs.test
              EOF

  tags = merge(local.tags, {
    Name = "greenbox-${count.index + 1}"
  })
}

# Adjuntar instancias nuevas al NLB
resource "aws_lb_target_group_attachment" "greenbox_attachment" {
  count            = length(aws_instance.greenbox)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = aws_instance.greenbox[count.index].id
  port             = 80
}
