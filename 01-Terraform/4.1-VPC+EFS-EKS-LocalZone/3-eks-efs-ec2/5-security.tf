# Este SG permite que las instancias EC2 puedan llegar al EFS
resource "aws_security_group" "efs" {
   name = "efs-sg"
   description= "Allow inbound efs traffic from ec2"
   vpc_id = "vpc-0c6f55212d2d771d5" # To change

   ingress {
     cidr_blocks = ["10.0.0.0/16"] # VPC CIDR
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }

   ingress {
     security_groups = [aws_security_group.ec2.id]
     from_port = 2049
     to_port = 2049 
     protocol = "tcp"
   }

   egress {
     cidr_blocks = ["10.0.0.0/16"] # VPC CIDR
     from_port = 0
     to_port = 0
     protocol = "-1"
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

 # El "ingress" de este SG se puede eliminar pq podemos acceder a las instancias desde la consola de AWS.
resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow efs outbound traffic"
  vpc_id = "vpc-0c6f55212d2d771d5"  # To change
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