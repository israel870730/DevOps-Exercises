import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ToDoList')

def lambda_handler(event, context):
    response = table.scan()
    tasks = response['Items']
    
    return {
        'statusCode': 200,
        'body': json.dumps(tasks)
    }
