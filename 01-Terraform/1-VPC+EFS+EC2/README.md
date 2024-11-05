# DevOps Exercises Terraform
VPC+EFS+EC2


# Ejemplo de como crear una instancia que se le instale una app determinada

resource "aws_instance" "webserver" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "web_server"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y 
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF
}