import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ToDoList')

def lambda_handler(event, context):
    body = json.loads(event['body'])
    task_id = str(uuid.uuid4())
    task_name = body['task_name']
    
    table.put_item(
        Item={
            'TaskId': task_id,
            'TaskName': task_name
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps({'task_id': task_id})
    }
