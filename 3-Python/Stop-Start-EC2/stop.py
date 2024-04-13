import boto3

def lambda_handler(event, context):
    aws_region = 'us-east-1'
    
    # Crea una sesión de cliente EC2
    ec2 = boto3.client('ec2', region_name=aws_region)
    
    # Define el tag por el que deseas filtrar las instancias
    tag_key = 'stop-start'
    tag_value = 'true'
    
    # Filtra las instancias por el tag
    response = ec2.describe_instances(Filters=[
        {
            'Name': f'tag:{tag_key}',
            'Values': [tag_value]
        }
    ])
    
    #print(response)
    
    # Obtiene las IDs de las instancias filtradas
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    
    # Detiene las instancias filtradas
    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)
        print(f'Instancias {instance_ids} detenidas exitosamente.')
    else:
        print('No se encontraron instancias para detener.')
