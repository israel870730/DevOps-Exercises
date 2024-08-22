# AWS Transfer Family

# Crear un servicio de SFTP usando AWS Transfer Family con las diferentes opciones;
## Endpoint type
    - Usando Route53
        - Hacer el ejemplo usando una zona privada en RT53
    - VPC hosted
## Domain (Choose the AWS Storage Service to store and access your data over the selected protocols)
    - S3
    - EFS

# Montar el EFS en Amazon Linux
- yum install amazon-efs-utils -y
- mkdir /opt/efs
- cd /opt
- Despues ir al EFS en AWS y en "Attach" copiar los detalles para montarlo