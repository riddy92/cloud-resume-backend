

data "archive_file" "lambda_update_dynamo_db" {
  type = "zip"

  source_dir  = "${path.module}/updateDynamoDB"
  excludes    = ["__pycache__"]
  output_path = "${path.module}/updateDynamoDB.zip"
}

resource "aws_s3_object" "lambda_update_dynamo_db" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "updateDynamoDB.zip"
  source = data.archive_file.lambda_update_dynamo_db.output_path

}


resource "aws_iam_role" "lambda_exec" {
  assume_role_policy    = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"}}],\"Version\":\"2012-10-17\"}"
  description           = null
  force_detach_policies = false
  managed_policy_arns   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"]
  max_session_duration  = 3600
  name                  = "updateDynamoDB-role-yjfauews"
  name_prefix           = null
  path                  = "/service-role/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}


resource "aws_lambda_function" "update-dynamo-db" {
  architectures                  = ["x86_64"]
  code_signing_config_arn        = null
  description                    = null
  filename                       = data.archive_file.lambda_update_dynamo_db.output_path
  function_name                  = "updateDynamoDB"
  handler                        = "lambda_function.lambda_handler"
  image_uri                      = null
  kms_key_arn                    = null
  layers                         = []
  memory_size                    = 128
  package_type                   = "Zip"
  publish                        = null
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.lambda_exec.arn
  runtime                        = "python3.10"
  s3_bucket                      = null
  s3_key                         = null
  s3_object_version              = null
  skip_destroy                   = false
  source_code_hash               = data.archive_file.lambda_update_dynamo_db.output_base64sha256
  tags                           = {}
  tags_all                       = {}
  timeout                        = 3
  ephemeral_storage {
    size = 512
  }
  tracing_config {
    mode = "PassThrough"
  }
}


resource "aws_cloudwatch_log_group" "lambda_function" {
  kms_key_id        = null
  name              = "/aws/lambda/updateDynamoDB"
  name_prefix       = null
  retention_in_days = 0
  skip_destroy      = null
  tags              = {}
  tags_all          = {}
}

