# Cómo alojar un sitio estático en un bucket de Amazon S3

## 1. Crear el bucket

El nombre del bucket debe coincidir con tu dominio (por ejemplo, `mi-sitio.com`). Créalo en la región que prefieras desde la consola de AWS o con la CLI:

```bash
aws s3 mb s3://mi-sitio.com --region us-east-1
```

## 2. Habilitar el alojamiento de sitio web estático

En la consola de S3, ve a tu bucket → **Properties** → **Static website hosting** → **Enable**. Configura lo siguiente:

- **Index document:** `index.html`
- **Error document:** `error.html` (opcional)

Con la CLI:

```bash
aws s3 website s3://mi-sitio.com \
  --index-document index.html \
  --error-document error.html
```

## 3. Desactivar "Block Public Access"

Por defecto, S3 bloquea el acceso público. Ve a **Permissions** → **Block public access** y desmarca todas las opciones (o solo las necesarias).

Con la CLI:

```bash
aws s3api put-public-access-block --bucket mi-sitio.com \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```

## 4. Agregar una política de bucket para acceso público de lectura

En **Permissions** → **Bucket policy**, agrega la siguiente política:

```json
{
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
```

> **Nota:** Reemplaza `mi-sitio.com` por el nombre real de tu bucket.

## 5. Subir los archivos del sitio

Sincroniza tu carpeta local con el bucket:

```bash
aws s3 sync ./mi-sitio/ s3://mi-sitio.com --delete
```

La bandera `--delete` elimina del bucket los archivos que ya no existan en la carpeta local.

## 6. Acceder al sitio

La URL del sitio tendrá el siguiente formato:

```
http://mi-sitio.com.s3-website-us-east-1.amazonaws.com
```

Puedes encontrarla en **Properties** → **Static website hosting** → **Endpoint**.

---

## Recomendaciones adicionales

### HTTPS con CloudFront

S3 estático solo sirve contenido por HTTP. Para habilitar HTTPS:

1. Crea una distribución de **CloudFront** apuntando al endpoint de tu bucket.
2. Solicita un certificado SSL gratuito en **AWS Certificate Manager (ACM)** en la región `us-east-1`.
3. Asocia el certificado a tu distribución de CloudFront.

### Dominio personalizado

Configura un registro **CNAME** o **Alias** en **Route 53** (u otro proveedor DNS) apuntando al endpoint de S3 o de CloudFront.

### Cache y rendimiento

Si usas CloudFront, configura políticas de caché y TTLs adecuados para mejorar la velocidad de carga y reducir costos.
