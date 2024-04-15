import boto3

def lambda_handler(event, context):
    # Definimos la region
    region = 'us-east-1'

    # ID de la instancias que vamos a iniciar
    instances = ['intances-ID','intances-ID']

    # Crea una sesión de cliente EC2
    ec2 = boto3.client('ec2', region_name=region)

    # Iniciamos las instancias
    ec2.stop_instances(InstanceIds=instances)
    print('Stopped your Instances: %s', str(instances))
