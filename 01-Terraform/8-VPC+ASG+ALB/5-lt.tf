######
# Launch configuration
######
resource "aws_launch_template" "demo_launch_template" {
  name   = "demo-launch-template"
  image_id      = local.ami
  instance_type = var.instance_type
  key_name                    = aws_key_pair.terraform_demo.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile {
    name = "${aws_iam_instance_profile.demo_profile.name}"
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  block_device_mappings {
    device_name = "/dev/sdb"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "*** Starting apache2"
  sudo systemctl start apache2
  echo "*** Enable apache2"
  sudo systemctl enable apache2
  echo "*** Edit file index.html"
  echo "<h1>Hello world from $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }

   monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Demo"
      Environment   = "POC",
      Terraform     = "True"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "Demo"
      Environment   = "POC",
      Terraform     = "True"
    }
  }
}

#Definimos la Key Pair que va a usar nuestras instancias EC2
resource "aws_key_pair" "terraform_demo" {
  key_name   = "terraform_demo"
  public_key = "${file(var.public_key)}"
}