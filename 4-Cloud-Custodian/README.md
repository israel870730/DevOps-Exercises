# Cloud Custodian folder

# Crear env de Python3 e instalar Cloud Custodian en ese entorno
    python3 -m venv custodian
    source custodian/bin/activate
    pip install c7n
    
    Nota: Si el contenedor es nuevo instalar python3.8-venv
    - apt update && apt install python3.8-venv -y

# Validar la plantilla de cloudcustodian
    custodian validate policies/1-add-tag-ec2-instances.yaml

# Ejecutar la plantilla de cloudcustodian para agregar tag
    # Probar primero con la opcion "--dryrun"
    custodian run --dryrun -s output policies/1-add-tag-ec2-instances.yaml --cache-period 0 --region=us-west-1
    
    # Ejecutar
    custodian run -s output policies/1-add-tag-ec2-instances.yaml --cache-period 0 --region=us-west-1

# Para crear lambda que start y stop ec2 instanes en un horario determinado
    Primero exportar el perfil que voy a usar
    - export AWS_PROFILE=poc
    Despues ejecutar la policy
        - custodian run --dryrun -s output policies/2-stop-ec2-instances.yaml --region=us-west-1 --cache-period 0
        - custodian run -s output policies/2-stop-ec2-instances.yaml --region=us-west-1 --cache-period 0
        
        - custodian run --dryrun -s output policies/3-start-ec2-instances.yaml --region=us-west-1 --cache-period 0
        - custodian run -s output policies/3-start-ec2-instances.yaml --region=us-west-1 --cache-period 0

    Esto crea automaticamente 2 funciones lambdas para estas tareas
    Para que la lambda funciones las intancias deben tener los tag

    Si queremos hacer un reporte sobre eso que se ejecuto anteriormente ejecutamos lo sgte: 
    - custodian report -s output policies/2-stop-ec2-instances.yaml --region=us-west-1

# Documentation
    https://medium.com/globant/cloud-custodian-easy-way-to-explore-instances-in-aws-cloud-2544e075303d
    https://cloudcustodian.io/docs/aws/policy/lambda.html
    https://cloudcustodian.io/docs/usecases/ec2offhours.html
    https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html


# Ejecutar la plantilla de cloudcustodian para buscar instance ec2 en diferentes regiones de una cuenta,
   Especificar cual perfil de AWS esta usando, si no pone ninguno toma el que esta por defecto
   custodian run --dryrun \
    -s output policies/find-ec2.yml \
    --cache-period 0 \
    --region us-east-1 \
    --region us-west-1 \
    --region us-east-2 \
    --region us-west-2 \
    --region eu-west-1 \
    --region eu-west-2 \
    --region eu-central-1 \
    --region ap-south-1 \
    --region ap-southeast-2 \
    --profile poc \ 

# Buscar un certificado CM 
    custodian run --dryrun \
    -s output policies/find-certificate.yml \
    --cache-period 0 \
    --region us-east-1

