import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ToDoList')

def lambda_handler(event, context):
    body = json.loads(event['body'])
    task_id = body['task_id']
    
    table.delete_item(
        Key={
            'TaskId': task_id
        }
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps({'deleted_task_id': task_id})
    }
