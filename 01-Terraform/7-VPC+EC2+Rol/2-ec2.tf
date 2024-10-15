resource "aws_instance" "demo_cloud_custodian" {
    count = 2
    #ami = "ami-ID"
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.cloud_custodian_sg.id]
    tags= {
        Name = "Demo-Cloud-Custodian"
    }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al202*-ami-202*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}
