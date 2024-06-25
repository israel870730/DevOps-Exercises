# To Do List

Vamos a crear un ejemplo donde se utiliza AWS CloudFront, S3, API Gateway, Lambda y DynamoDB para implementar una aplicación web simple. Este ejemplo será una aplicación de "To-Do List" donde los usuarios pueden agregar, ver y eliminar tareas.

## Arquitectura
S3: Almacenará el contenido estático de la aplicación (HTML, CSS, JS).
CloudFront: Servirá como CDN para distribuir el contenido estático desde S3.
API Gateway: Actuará como la puerta de entrada para las solicitudes HTTP hacia las funciones Lambda.
Lambda: Contendrá la lógica de backend para manejar las solicitudes de la API.
DynamoDB: Almacenará las tareas de la "To-Do List".

## Pasos para Implementar la Solución
1. Configurar S3 y CloudFront
Crear un bucket en S3:
Crea un bucket en S3 para almacenar tu contenido estático.
Sube tus archivos HTML, CSS y JavaScript al bucket.
Habilita el acceso público para el bucket y configura las políticas adecuadas.

Configurar CloudFront:
Crea una distribución de CloudFront que apunte a tu bucket de S3.
Configura los ajustes de la distribución, como el origen, el comportamiento de caché, etc.

2. Configurar DynamoDB
Crear una tabla en DynamoDB:
Crea una tabla llamada ToDoList con una clave primaria TaskId (tipo String).

3. Configurar Lambda y API Gateway
Crear funciones Lambda en Python:
Crea tres funciones Lambda para manejar las operaciones de la "To-Do List":
CreateTask: para agregar tareas.
GetTasks: para obtener la lista de tareas.
DeleteTask: para eliminar tareas.

Configurar API Gateway:
Crea una API REST en API Gateway.
Crea los recursos y métodos necesarios (/tasks con métodos POST, GET y DELETE).
Conecta cada método a su correspondiente función Lambda.
