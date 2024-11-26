resource "aws_instance" "ec2-vpc-1" {
    count = 1
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.poc_profile.name}"
    subnet_id = module.vpc-1.private_subnets[0]
    #associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2-vpc-1.id]
    key_name="demo-efs"
    tags= {
        Name = "ec2-vpc-1"
    }

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update 
  sudo yum -y install telnet
  EOF
}

resource "aws_instance" "ec2-vpc-2" {
    count = 1
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.poc_profile.name}"
    subnet_id = module.vpc-2.private_subnets[0]
    #associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2-vpc-2.id]
    key_name="demo-efs"
    tags= {
        Name = "ec2-vpc-2"
    }

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update 
  sudo yum -y install telnet
  EOF
}
