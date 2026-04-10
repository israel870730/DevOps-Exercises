1. Crear el bucket
El nombre del bucket debe coincidir con tu dominio (por ejemplo, mi-sitio.com). Créalo en la región que prefieras desde la consola de AWS o con la CLI:
bashaws s3 mb s3://mi-sitio.com --region us-east-1

2. Habilitar el alojamiento de sitio web estático
En la consola de S3, ve a tu bucket → Properties → Static website hosting → Enable. Configura el documento de índice (index.html) y opcionalmente un documento de error (error.html). Con la CLI:
bashaws s3 website s3://mi-sitio.com \
  --index-document index.html \
  --error-document error.html

3. Desactivar "Block Public Access"
Por defecto, S3 bloquea el acceso público. Ve a Permissions → Block public access y desmarca todas las opciones (o solo las necesarias). Con la CLI:
bashaws s3api put-public-access-block --bucket mi-sitio.com \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

4. Agregar una política de bucket para acceso público de lectura
En Permissions → Bucket policy, agrega:
json{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mi-sitio.com/*"
    }
  ]
}

5. Subir los archivos
bashaws s3 sync ./mi-sitio/ s3://mi-sitio.com --delete

6. Acceder al sitio
La URL será algo como:
http://mi-sitio.com.s3-website-us-east-1.amazonaws.com
La encuentras en Properties → Static website hosting → Endpoint.

# Recomendaciones adicionales:

- HTTPS con CloudFront: S3 estático solo sirve HTTP. Para HTTPS, coloca una distribución de CloudFront delante del bucket y asocia un certificado de ACM.
- Dominio personalizado: Configura un registro CNAME o Alias en Route 53 (u otro DNS) apuntando al endpoint de S3 o de CloudFront.
- Cache y rendimiento: Si usas CloudFront, configura políticas de caché y TTLs para mejorar la velocidad de carga.