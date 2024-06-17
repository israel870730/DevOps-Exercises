# El "ingress" de este SG se puede eliminar pq podemos acceder a las instancias desde la consola de AWS.
resource "aws_security_group" "cloud_custodian_sg" {
  name        = "cloud-custodian-sg"
  description = "SG-EC2"
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
    Name = "cloud-Custodian-SG"
  }
}