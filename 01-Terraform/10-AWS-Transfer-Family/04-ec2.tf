# Linux
resource "aws_instance" "linuxinstance" {
    count = 1
    ami = "ami-04fdea8e25817cd69" # al2023-ami-2023.5.20240819.0-kernel-6.1-x86_64
    instance_type = "t2.medium"
    iam_instance_profile = "${aws_iam_instance_profile.poc_profile.name}"
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2.id]
    key_name="demo-20240820"
    tags= {
        Name = "demo-linux-awstf"
    }
}

# Windows
resource "aws_instance" "windowsinstance" {
    count = 1
    ami = "ami-0543f26574a9c23ed" # Windows_Server-2019-English-Full-Base-2024.08.14
    instance_type = "t2.medium"
    iam_instance_profile = "${aws_iam_instance_profile.poc_profile.name}"
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2.id]
    key_name="demo-20240820"
    tags= {
        Name = "demo-windows-awstf"
    }
}