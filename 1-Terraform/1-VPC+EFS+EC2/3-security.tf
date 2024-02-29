resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow efs outbound traffic"
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