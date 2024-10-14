

resource "aws_apigatewayv2_api" "lambda" {
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  credentials_arn              = null
  description                  = "Created by AWS Lambda"
  disable_execute_api_endpoint = false
  fail_on_warnings             = null
  name                         = "updateDynamoDB-API"
  protocol_type                = "HTTP"
  route_key                    = null
  route_selection_expression   = "$request.method $request.path"
  tags                         = {}
  tags_all                     = {}
  target                       = null
  version                      = null
  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_methods     = []
    allow_origins     = ["*"]
    expose_headers    = []
    max_age           = 0
  }
}

resource "aws_apigatewayv2_deployment" "lambda" {
  api_id      = aws_apigatewayv2_api.lambda.id
  description = "Automatic deployment triggered by changes to the Api configuration"
  triggers    = null
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id                = aws_apigatewayv2_api.lambda.id
  auto_deploy           = true
  client_certificate_id = null
  # deployment_id         = aws_apigatewayv2_deployment.lambda.id
  description           = "Created by AWS Lambda"
  name                  = "default"
  stage_variables       = {}
  tags                  = {}
  tags_all              = {}
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.stage $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  }
  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    logging_level            = null
    throttling_burst_limit   = 0
    throttling_rate_limit    = 0
  }
}

resource "aws_apigatewayv2_stage" "lambda_dev" {
  api_id                = aws_apigatewayv2_api.lambda.id
  auto_deploy           = true
  client_certificate_id = null
  # deployment_id         = aws_apigatewayv2_deployment.lambda.id
  description           = "Created by AWS Lambda"
  name                  = "dev"
  stage_variables       = {}
  tags                  = {}
  tags_all              = {}
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.stage $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  }
  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    logging_level            = null
    throttling_burst_limit   = 0
    throttling_rate_limit    = 0
  }
}



resource "aws_apigatewayv2_integration" "update-dynamo-db" {
  api_id                        = aws_apigatewayv2_api.lambda.id
  connection_id                 = null
  connection_type               = "INTERNET"
  content_handling_strategy     = null
  credentials_arn               = null
  description                   = null
  integration_method            = "POST"
  integration_subtype           = null
  integration_type              = "AWS_PROXY"
  integration_uri               = aws_lambda_function.update-dynamo-db.arn
  passthrough_behavior          = null
  payload_format_version        = "1.0"
  request_parameters            = {}
  request_templates             = {}
  template_selection_expression = null
  timeout_milliseconds          = 30000
}



resource "aws_apigatewayv2_route" "update-dynamo-db" {
  api_id                              = aws_apigatewayv2_api.lambda.id
  api_key_required                    = false
  authorization_scopes                = []
  authorization_type                  = "NONE"
  authorizer_id                       = null
  model_selection_expression          = null
  operation_name                      = null
  request_models                      = {}
  route_key                           = "ANY /updateDynamoDB"
  route_response_selection_expression = null
  target                              = "integrations/${aws_apigatewayv2_integration.update-dynamo-db.id}"
}



resource "aws_cloudwatch_log_group" "api_gw" {
  kms_key_id        = null
  name              = "/aws/ApiGateway/${aws_apigatewayv2_api.lambda.name}"
  name_prefix       = null
  retention_in_days = 0
  skip_destroy      = null
  tags              = {}
  tags_all          = {}
}



resource "aws_lambda_permission" "api_gw" {
  action                 = "lambda:InvokeFunction"
  event_source_token     = null
  function_name          = aws_lambda_function.update-dynamo-db.arn
  function_url_auth_type = null
  principal              = "apigateway.amazonaws.com"
  principal_org_id       = null
  qualifier              = null
  source_account         = null
  source_arn             = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*/updateDynamoDB"
  statement_id           = "lambda-a19b4956-0fcf-49ef-8126-29fd1f072138"
  statement_id_prefix    = null
}

