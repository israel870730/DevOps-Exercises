#Instancias EC2
resource "aws_instance" "demo" {
  for_each                    = var.servidores
  ami                         = local.ami
  instance_type               = var.instance_type
  iam_instance_profile        = "${aws_iam_instance_profile.demo_profile.name}"
  /* Definimos un mapa az_to_index en el fichero locals para mapear cada AZ a su índice correspondiente en la lista de subredes públicas.
  Usamos element(module.vpc.public_subnets, local.az_to_index[each.value.az]) para seleccionar la subred correcta basada 
  en la AZ especificada en var.servidores. */
  #subnet_id                   = element(module.vpc.public_subnets, local.az_to_index[each.value.az])
  subnet_id                   = element(module.vpc.private_subnets, local.az_to_index[each.value.az])
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
  echo "<h1>Hello world from - ${each.value.nombre}</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    "Name" = each.value.nombre
  }
}

#Definimos la Key Pair que va a usar nuestras instancias EC2
resource "aws_key_pair" "terraform_demo" {
  key_name   = "terraform_demo"
  public_key = "${file(var.public_key)}"
}
