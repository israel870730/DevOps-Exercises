# Usa la imagen oficial de Ubuntu como base
FROM ubuntu:latest

# Actualiza los repositorios e instala las dependencias
RUN apt-get update && apt-get install -y wget unzip git python3 python3-pip curl jq

# Descarga e instala Packer
RUN wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip && \
    unzip packer_1.9.4_linux_amd64.zip -d /usr/local/bin && \
    rm packer_1.9.4_linux_amd64.zip

# Descarga e instala la CLI de AWS
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.7.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Limpia el caché de paquetes
RUN apt-get clean

# Configura la variable de entorno PATH para incluir /usr/local/bin
ENV PATH="/usr/local/bin:${PATH}"

# Comando predeterminado al ejecutar el contenedor
CMD ["packer", "--version"]
