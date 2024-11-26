# Pasos para crear la img y subirla a docker hub
- docker build -t troubleshooting:v1.0 .
- docker login
- docker tag troubleshooting:v1.0 nombre_usuario/nombre_repositorio:tag
- docker push nombre_usuario/nombre_repositorio:tag

- docker build -t telnet:v1.0 .
- docker run -it --rm --name troubleshooting ping:v1.0 8.8.8.8 -c 5

- docker build -t ping:v1.0 .
- docker run -it --rm --name troubleshooting telnet:v1.0 google.com 443

# Test
- docker run -it --rm --name troubleshooting troubleshooting:v1.0 sh
- docker run -it --rm --name test testalpine:v1.0 sh

- docker run -it --rm --name troubleshooting 870730/ekstroubleshooting:telnet google.com 443
- docker run -it --rm --name troubleshooting 870730/ekstroubleshooting:pingV16 8.8.8.8 -c 5
- docker run -it --rm --name troubleshooting 870730/ekstroubleshooting:latest /bin/sh


# Para ver los paquetes instalados en la imagen
- ls /bin

# Despues que la imagen este en un repo ejecutar
- kubectl run tmp -it --restart=Never --image=troubleshooting:v1.0 --tty --rm /bin/sh 
- kubectl run tmp -it --restart=Never --rm --image=870730/ekstroubleshooting:T1 --tty /bin/sh

- kubectl run tmp -it --restart=Never --rm --image=870730/ekstroubleshooting:pingV9 -- 127.0.0.1
- kubectl run tmp -it --restart=Never --rm --image=870730/ekstroubleshooting:pingV16 -- 127.0.0.1

- kubectl run tmp -it --restart=Never --rm --image=870730/ekstroubleshooting:telnetv4 -- google.com 443
- kubectl run tmp -it --restart=Never --rm --image=870730/ekstroubleshooting:T1 -- nc -vvv 10.1.0.44 80

# Pasos para Jfrog repository
- docker build -t troubleshooting:v1.0 .
- docker login images.cloudops
- docker tag troubleshooting:v1.0 israel/images.cloudops:tag
- docker push images.cloudops/troubleshooting:v1.0


