import boto3
import json

client = boto3.client('dynamodb')

def lambda_handler(event, context):

    stage = event.get("requestContext")["stage"]

    if stage == 'default':
     
        # need to pull current value of counter then add +1
        # then update value in dynamo
        data = client.update_item(
            Key={
                "count id":{"N":"1"}
            },
            ExpressionAttributeNames={
            "#ct": 'count',
            },
            ExpressionAttributeValues={
                ":ct":{"N":"1"}                             
            },
            UpdateExpression="SET #ct = #ct + :ct",
            TableName='visitors_counter',
            ReturnValues='ALL_NEW',
        )
    else:

        # need to pull current value of counter then add +1
        # then update value in dynamo
        data = client.update_item(
            Key={
                "count id":{"N":"2"}
            },
            ExpressionAttributeNames={
            "#ct": 'count',
            },
            ExpressionAttributeValues={
                ":ct":{"N":"1"}                             
            },
            UpdateExpression="SET #ct = #ct + :ct",
            TableName='visitors_counter',
            ReturnValues='ALL_NEW',
        )

    

    return {
        'statusCode': 200,
        'body': json.dumps(data),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
    }
