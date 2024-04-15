resource "aws_instance" "testinstance" {
    count = 1
    ami = "ami-05af0694d2e8e6df3"
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.poc_profile.name}" # Aqui le paso un rol que voy a crear llamado "test_role"
    #iam_instance_profile = "demo" # Aqui le paso un rol que ya esta creado 
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2.id]
    key_name="demo-efs"
    tags= {
        Name = "demo-rds"
    }

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update 
  sudo yum -y install telnet
  EOF
}