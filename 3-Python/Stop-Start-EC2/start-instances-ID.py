import boto3

region = 'us-east-1'
instances = ['i-0819b90f34be768f6','i-080ae94dd036e6a57','i-04ad08a3135c38fe6','i-0855dfd53845f745b','i-0a9f3ae1a9859371f']

def lambda_handler(event, context):
    ec2 = boto3.client('ec2', region_name=region)
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: %s', str(instances))
