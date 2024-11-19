#SG instancias EC2
resource "aws_security_group" "ec2_sg" {
  name          = "SG-EC2"
  description   = "SG-EC2"
  vpc_id        = module.vpc.vpc_id
  ingress {
    security_groups = [aws_security_group.alb_sg.id]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = var.puerto_servidor
    to_port     = var.puerto_servidor
    protocol    = "TCP"
  }
  # ingress {
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Acceso al puerto 22 desde el exterior"
  #   from_port   = var.puerto_ssh
  #   to_port     = var.puerto_ssh
  #   protocol    = "TCP"
  # }
  ingress {
    cidr_blocks = ["${var.home_ip}/32"]
    description = "Acceso al puerto 22 solo desde la IP de casa"
    from_port   = var.puerto_ssh
    to_port     = var.puerto_ssh
    protocol    = "TCP"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Salida full internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

#SG ALB
resource "aws_security_group" "alb_sg" {
  name          = "SG-ALB"
  description   = "SG-ALB"
  vpc_id        = module.vpc.vpc_id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = var.puerto_lb
    to_port     = var.puerto_lb
    protocol    = "TCP"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Salida full internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}