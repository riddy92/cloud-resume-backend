import os
import sys
import pytest
from moto import mock_aws
import boto3
import json



sys.path.insert(0, '../updateDynamoDB')

# Sample Event
event = {
    "body": { "test": "body"},
    "resource": "/{proxy+}",
    "requestContext": {
        "resourceId": "123456",
        "apiId": "1234567890",
        "resourcePath": "/{proxy+}",
        "httpMethod": "POST",
        "requestId": "c6af9ac6-7b61-11e6-9a41-93e8deadbeef",
        "accountId": "123456789012",
        "identity": {
            "apiKey": "",
            "userArn": "",
            "cognitoAuthenticationType": "",
            "caller": "",
            "userAgent": "Custom User Agent String",
            "user": "",
            "cognitoIdentityPoolId": "",
            "cognitoIdentityId": "",
            "cognitoAuthenticationProvider": "",
            "sourceIp": "127.0.0.1",
            "accountId": ""
        },
        "stage": "prod"
    },
    "queryStringParameters": {"foo": "bar"},
    "headers": {
        "Via": "1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)",
        "Accept-Language": "en-US,en;q=0.8",
        "CloudFront-Is-Desktop-Viewer": "true",
        "CloudFront-Is-SmartTV-Viewer": "false",
        "CloudFront-Is-Mobile-Viewer": "false",
        "X-Forwarded-For": "127.0.0.1, 127.0.0.2",
        "CloudFront-Viewer-Country": "US",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Upgrade-Insecure-Requests": "1",
        "X-Forwarded-Port": "443",
        "Host": "1234567890.execute-api.us-east-1.amazonaws.com",
        "X-Forwarded-Proto": "https",
        "X-Amz-Cf-Id": "aaaaaaaaaae3VYQb9jd-nvCd-de396Uhbp027Y2JvkCPNLmGJHqlaA==",
        "CloudFront-Is-Tablet-Viewer": "false",
        "Cache-Control": "max-age=0",
        "User-Agent": "Custom User Agent String",
        "CloudFront-Forwarded-Proto": "https",
        "Accept-Encoding": "gzip, deflate, sdch"
    },
    "pathParameters":  { "docType" : "WELCOME", "customerId" : "SampleCustomer0001" },
    "httpMethod": "POST",
    "stageVariables": {"baz": "qux"},
    "path": "/examplepath"
}



@pytest.fixture(scope="function")
def aws_credentials():
    """Mocked AWS Credentials for moto."""
    os.environ["AWS_ACCESS_KEY_ID"] = "testing"
    os.environ["AWS_SECRET_ACCESS_KEY"] = "testing"
    os.environ["AWS_SECURITY_TOKEN"] = "testing"
    os.environ["AWS_SESSION_TOKEN"] = "testing"
    os.environ["AWS_DEFAULT_REGION"] = "us-east-1"

@pytest.fixture(scope="function")
def dynamodb(aws_credentials):
    with mock_aws():
        yield boto3.client("dynamodb", region_name="us-east-1")

@pytest.fixture(scope='function')
def dynamodb_table(dynamodb):
    table = dynamodb.create_table(
    AttributeDefinitions=[
        {
            'AttributeName': 'count id',
            'AttributeType': 'N',
        },
    ],
    KeySchema=[
        {
            'AttributeName': 'count id',
            'KeyType': 'HASH',
        },
    ],
    ProvisionedThroughput={
        'ReadCapacityUnits': 1,
        'WriteCapacityUnits': 1,
    },
    TableName='visitors_counter',
    )

    dynamodb.put_item(
    Item={
        'count id': {
            'N': '1',
        },
        'count': {
            'N': '1',
        },
    },
    ReturnConsumedCapacity='TOTAL',
    TableName='visitors_counter',
    )
     
    #wait for table to be in ACTIVE state
    waiter = dynamodb.get_waiter("table_exists")
    waiter_config = {"Delay": 2, "MaxAttempts": 10}
    waiter.wait(TableName='visitors_counter', WaiterConfig=waiter_config)
    yield


def test_status_code(dynamodb,monkeypatch,dynamodb_table):
    from updateDynamoDB.lambda_function import lambda_handler
    from updateDynamoDB import lambda_function
    client = dynamodb
    monkeypatch.setattr(lambda_function,"client",client) 
    response = lambda_handler(event,context=None)
    # assert response["ResponseMetadata"]["HTTPStatusCode"] == 200
    assert response["statusCode"] == 200
    

def test_update_item(dynamodb,monkeypatch,dynamodb_table):
    from updateDynamoDB.lambda_function import lambda_handler
    from updateDynamoDB import lambda_function
    client = dynamodb
    monkeypatch.setattr(lambda_function,"client",client) 
    response = lambda_handler(event,context=None)
    body = json.loads(response["body"])
    assert body["Attributes"]["count"]["N"] == "2"
    



