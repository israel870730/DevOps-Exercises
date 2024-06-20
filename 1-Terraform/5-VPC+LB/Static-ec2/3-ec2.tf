#Instancia #1
resource "aws_instance" "demo_1" {
  ami                         = local.ami
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.terraform_demo.id
  user_data                   = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "*** Staring apache2"
  sudo systemctl start apache2
  echo "*** Enable apache2"
  sudo systemctl enable apache2
  echo "*** Edit file index.html"
  echo "<h1>Hello world from - Server 1</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    "Name" = "Demo-1"
  }
}

#Instancia #2
resource "aws_instance" "demo_2" {
  ami                         = local.ami
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.terraform_demo.id
  user_data                   = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "*** Staring apache2"
  sudo systemctl start apache2
  echo "*** Enable apache2"
  sudo systemctl enable apache2
  echo "*** Edit file index.html"
  echo "<h1>Hello world from - Server 2</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    "Name" = "Demo-2"
  }
}

#Definimos la Key Pair que va a usar nuestras instancias EC2
resource "aws_key_pair" "terraform_demo" {
  key_name   = "terraform_demo"
  public_key = "${file(var.public_key)}"
}
