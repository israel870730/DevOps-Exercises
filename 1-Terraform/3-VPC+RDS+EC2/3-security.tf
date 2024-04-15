# El "ingress" de este SG se puede eliminar pq podemos acceder a las instancias desde la consola de AWS.
resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
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
    Name = "ec2-sg"
  }
}

# Este SG permite que las instancias EC2 puedan llegar a la RDS
resource "aws_security_group" "rds" {
   name = "rds-sg"
   description= "SG-RDS"
   vpc_id = module.vpc.vpc_id

   ingress {
     security_groups = [aws_security_group.ec2.id]
     from_port = 3306
     to_port = 3306 
     protocol = "tcp"
   }     
        
   egress {
     security_groups = [aws_security_group.ec2.id]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
   tags = {
    Name = "rds-sg"
  }
 }