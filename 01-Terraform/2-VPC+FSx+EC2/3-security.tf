resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Allow efs outbound traffic"
  vpc_id = module.vpc.vpc_id
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 3389
     to_port = 3389
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

resource "aws_security_group" "fsx" {
   name = "fsx-sg"
   description= "Allow inbound fsx traffic"
   vpc_id = module.vpc.vpc_id

  ingress {
     #security_groups = [aws_security_group.ec2.id]
     cidr_blocks = module.vpc.private_subnets_cidr_blocks
     from_port = 0
     to_port = 0 
     protocol = "-1"
   }      
        
   egress {
     #security_groups = [aws_security_group.ec2.id]
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 0
     to_port = 0
     protocol = "-1"
   }
   tags = {
    Name = "fsx-sg"
  }
 }