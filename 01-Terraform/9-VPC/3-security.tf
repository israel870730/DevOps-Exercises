# El "ingress" de este SG se puede eliminar pq podemos acceder a las instancias desde la consola de AWS.
resource "aws_security_group" "ec2-vpc-1" {
  name        = "ec2-sg"
  description = "SG-EC2"
  vpc_id = module.vpc-1.vpc_id
  # Regla para SSH
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 22
     to_port = 22
     protocol = "tcp"
   }
  # Regla para permitir ping (ICMP)
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1      # Permite todos los tipos de mensajes ICMP
    to_port     = -1
    protocol    = "icmp"
  }
  # Regla de salida predeterminada
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_security_group" "ec2-vpc-2" {
  name        = "ec2-sg"
  description = "SG-EC2"
  vpc_id = module.vpc-2.vpc_id
  # Regla para SSH
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 22
     to_port = 22
     protocol = "tcp"
   }
  # Regla para permitir ping (ICMP)
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1      # Permite todos los tipos de mensajes ICMP
    to_port     = -1
    protocol    = "icmp"
  }
  # Regla de salida predeterminada
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-sg"
  }
}