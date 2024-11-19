resource "aws_instance" "jumbox" {
    #count = 1
    #ami = "ami-05af0694d2e8e6df3"
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    iam_instance_profile = "${aws_iam_instance_profile.demo_profile.name}"
    #iam_instance_profile = "demo" # Aqui le paso un rol que ya esta creado 
    subnet_id = module.vpc.public_subnets[0]
    associate_public_ip_address= true
    vpc_security_group_ids = [aws_security_group.ec2.id]
    #key_name="demo"
    tags= {
        Name = "Jumbox"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update 
                sudo yum -y install telnet git
                # Install Kubectl
                curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.8/2024-04-19/bin/linux/amd64/kubectl
                curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.8/2024-04-19/bin/linux/amd64/kubectl.sha256
                openssl sha1 -sha256 kubectl
                chmod +x ./kubectl
                mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
                echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
                kubectl version --client
                # Install Helm
                curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
                chmod 700 get_helm.sh
                ./get_helm.sh
                helm version
                # Install Terraform
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
                sudo yum -y install terraform
                EOF
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
