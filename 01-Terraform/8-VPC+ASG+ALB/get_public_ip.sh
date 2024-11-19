#!/bin/bash

# Obtener la IP pública
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# Exportar la IP pública como variable de entorno
#export TF_VAR_home_ip=$PUBLIC_IP

# Añadir o actualizar la variable home_ip en el archivo demo.auto.tfvars
if grep -q "home_ip" 11-demo.auto.tfvars; then
  # Si home_ip ya existe en el archivo, reemplazar su valor
  sed -i "s/^home_ip.*/home_ip = \"$PUBLIC_IP\"/" 11-demo.auto.tfvars
else
  # Si home_ip no existe en el archivo, agregarlo
  echo "home_ip = \"$PUBLIC_IP\"" >> demo.auto.tfvars
fi

# Imprimir la IP pública
echo "La IP pública de la casa es: $PUBLIC_IP"
