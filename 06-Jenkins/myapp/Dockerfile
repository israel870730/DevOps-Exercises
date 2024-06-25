# Usar una imagen de PHP con servidor web Apache
FROM php:apache

# Copiar los archivos del código fuente al contenedor
COPY . /var/www/html/

# Exponer el puerto 80
EXPOSE 80

# Iniciar el servidor Apache al ejecutar el contenedor
CMD ["apache2-foreground"]
