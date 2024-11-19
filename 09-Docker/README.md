# Docker folder

- https://israel870730.com/liberar-espacio-ocupado-por-docker/

# Agregar al docker file

- sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
- sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
- sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

- fuente: https://github.com/ahmetb/kubectx
- Agregar alias al docker file


# Para crear la imagen de docker
- docker build -t imgpersonal .

# Para subir las imagenes a mi docker hub:
- Loguearse: 
  - docker login
- Taguear la imagen a subir
  - docker tag new-imgpersonal 870730/new-imgpersonal
- Subir la imagen
   - docker push 870730/new-imgpersonal

# Ejecutar en windows y montar un volumen
- docker.exe run -itd --name terraform1 -v "C:\Users\israel\terraform\":/data/ ubuntu:20.04 /bin/bash