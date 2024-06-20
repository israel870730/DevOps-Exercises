#Instancias EC2
resource "aws_instance" "demo" {
  count                       = var.instance_count
  ami                         = local.ami
  instance_type               = var.instance_type
  iam_instance_profile        = "${aws_iam_instance_profile.demo_profile.name}"
  /*La función element toma dos argumentos: una lista y un índice, y devuelve el elemento de la lista en la posición dada por el índice. 
  En este caso, selecciona una subred de module.vpc.public_subnets utilizando el índice calculado por 
  count.index % length(module.vpc.public_subnets).*/
  subnet_id                   = element(module.vpc.public_subnets, count.index % length(module.vpc.public_subnets))
  #associate_public_ip_address = true
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
  echo "<h1>Hello world from - ${var.instance_names[count.index]}</h1>" | sudo tee /var/www/html/index.html
  echo "<p>$(hostname -f)</p>" | sudo tee -a /var/www/html/index.html
  EOF

  tags = {
    "Name" = var.instance_names[count.index]
  }
}

#Definimos la Key Pair que va a usar nuestras instancias EC2
resource "aws_key_pair" "terraform_demo" {
  key_name   = "terraform_demo"
  public_key = "${file(var.public_key)}"
}
