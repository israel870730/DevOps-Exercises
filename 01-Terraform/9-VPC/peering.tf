# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options
# Crear el VPC Peering
resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = module.vpc-1.vpc_id
  peer_vpc_id   = module.vpc-2.vpc_id
  auto_accept   = true  # Cambia a true si quieres que se acepte automáticamente
  peer_owner_id = data.aws_caller_identity.current.account_id
  tags= {
        Name = "peering-from-vpc-1-to-vpc-2"
    }
}

# Aceptar el VPC Peering
resource "aws_vpc_peering_connection_accepter" "peering_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
}

# Nota: Si solo tienes una tabla de rutas privada por VPC, usa la solución con índices estáticos para simplificar el código. Si tienes múltiples tablas de rutas, usa la solución del map.
# Actualizar las tablas de rutas en ambas VPCs
resource "aws_route" "public_vpc1_to_vpc2" {
  # Si sabes cuántas tablas de rutas privadas tendrás (lo cual parece ser 1 por VPC en este caso), 
  # puedes usar los índices directamente en lugar de for_each.
  route_table_id         = module.vpc-1.public_route_table_ids[0] # O el route table de subnets privadas
  destination_cidr_block = module.vpc-2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "public_vpc2_to_vpc1" {
  # Si sabes cuántas tablas de rutas privadas tendrás (lo cual parece ser 1 por VPC en este caso), 
  # puedes usar los índices directamente en lugar de for_each.
  route_table_id         = module.vpc-2.public_route_table_ids[0] # O el route table de subnets privadas
  destination_cidr_block = module.vpc-1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Ruta desde las tablas de rutas privadas de vpc-1 hacia vpc-2
resource "aws_route" "private_vpc1_to_vpc2" {
  # Este ejemplo falla porque module.vpc-1.private_route_table_ids tiene valores dinámicos que no están disponibles en el momento de la planificación de Terraform (plan). 
  # Esto sucede cuando Terraform no puede determinar cuántos elementos habrá en for_each antes de aplicar los cambios.   
  #for_each              = toset(module.vpc-1.private_route_table_ids)

  #Convierte los valores dinámicos en un map que Terraform pueda calcular durante la planificación.
  for_each              = { for idx, route_table_id in module.vpc-1.private_route_table_ids : idx => route_table_id }

  route_table_id        = each.value
  destination_cidr_block = module.vpc-2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Ruta desde las tablas de rutas privadas de vpc-2 hacia vpc-1
resource "aws_route" "private_vpc2_to_vpc1" {
  # Este ejemplo falla porque module.vpc-2.private_route_table_ids tiene valores dinámicos que no están disponibles en el momento de la planificación de Terraform (plan). 
  # Esto sucede cuando Terraform no puede determinar cuántos elementos habrá en for_each antes de aplicar los cambios.
  #for_each              = toset(module.vpc-2.private_route_table_ids)

  #Convierte los valores dinámicos en un map que Terraform pueda calcular durante la planificación.
  for_each              = { for idx, route_table_id in module.vpc-2.private_route_table_ids : idx => route_table_id }

  route_table_id        = each.value
  destination_cidr_block = module.vpc-1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Data source para obtener la cuenta actual
data "aws_caller_identity" "current" {}

# Código para Habilitar DNS Resolution

# Configuración de opciones de VPC Peering para vpc-1
resource "aws_vpc_peering_connection_options" "vpc1_options" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  #vpc_id                    = module.vpc-1.vpc_id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

# Configuración de opciones de VPC Peering para vpc-2
resource "aws_vpc_peering_connection_options" "vpc2_options" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  #vpc_id                    = module.vpc-2.vpc_id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
