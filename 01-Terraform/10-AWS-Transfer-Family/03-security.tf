# El "ingress" de este SG se puede eliminar pq podemos acceder a las instancias desde la consola de AWS.
resource "aws_security_group" "ec2" {
  name        = "SG-EC2"
  description = "SG-EC2"
  vpc_id = module.vpc.vpc_id

  ingress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-EC2"
  }
}

# Este SG permite que las instancias EC2 puedan llegar al EFS
resource "aws_security_group" "efs" {
   name = "efs-sg"
   description= "Allow inbound efs traffic from ec2"
   vpc_id = module.vpc.vpc_id

   ingress {
     security_groups = [aws_security_group.ec2.id]
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }     
        
   egress {
     security_groups = [aws_security_group.ec2.id]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
   tags = {
    Name = "efs-sg"
  }
 }