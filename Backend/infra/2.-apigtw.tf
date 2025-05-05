###################################################################
# API Gateway
###################################################################
resource "aws_api_gateway_rest_api" "doggo-api" {
  name        = "doggo-api"
  description = "Doggo API Gateway"
}
###################################################################
## resource
###################################################################
# API Gateway resource Login
resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  parent_id   = aws_api_gateway_rest_api.doggo-api.root_resource_id
  path_part   = "login"
}

# GET method
resource "aws_api_gateway_method" "get_login" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway resource services
resource "aws_api_gateway_resource" "services" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  parent_id   = aws_api_gateway_rest_api.doggo-api.root_resource_id
  path_part   = "services"
}
# GET method
resource "aws_api_gateway_method" "get_services" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.services.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway resource messages
resource "aws_api_gateway_resource" "messages" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  parent_id   = aws_api_gateway_rest_api.doggo-api.root_resource_id
  path_part   = "messages"
}
# POST method
resource "aws_api_gateway_method" "post_messages" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "POST"
  authorization = "NONE"
}
# GET method
resource "aws_api_gateway_method" "get_messages" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.messages.id
  http_method   = "GET"
  authorization = "NONE"
}
# API Gateway resource sitters
resource "aws_api_gateway_resource" "sitters" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  parent_id   = aws_api_gateway_rest_api.doggo-api.root_resource_id
  path_part   = "sitters"
}
# GET method
resource "aws_api_gateway_method" "get_sitters" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.sitters.id
  http_method   = "GET"
  authorization = "NONE"
}
# API Gateway resource /schedule/{sitterId}
resource "aws_api_gateway_resource" "schedule" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  parent_id   = aws_api_gateway_rest_api.doggo-api.root_resource_id
  path_part   = "schedule"
}
# GET method
resource "aws_api_gateway_method" "get_schedule" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.schedule.id
  http_method   = "GET"
  authorization = "NONE"
}
# POST method
resource "aws_api_gateway_method" "post_schedule" {
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  resource_id   = aws_api_gateway_resource.schedule.id
  http_method   = "POST"
  authorization = "NONE"
}
###################################################################
## integration
###################################################################
# Lambda integration for GET login
resource "aws_api_gateway_integration" "lambda_get_login" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.login.id
  http_method = aws_api_gateway_method.get_login.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.login_lambda.invoke_arn
}

# Lambda integration for GET services
resource "aws_api_gateway_integration" "lambda_get_services" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.services.id
  http_method = aws_api_gateway_method.get_services.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.service_lambda.invoke_arn
}

# Lambda integration for GET messages
resource "aws_api_gateway_integration" "lambda_get_messages" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.get_messages.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.message_lambda.invoke_arn
}

# Lambda integration for POST messages
resource "aws_api_gateway_integration" "lambda_post_messages" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.messages.id
  http_method = aws_api_gateway_method.post_messages.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.message_lambda.invoke_arn
}

# Lambda integration for GET sitters
resource "aws_api_gateway_integration" "lambda_get_sitters" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.sitters.id
  http_method = aws_api_gateway_method.get_sitters.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.sitters_lambda.invoke_arn
}

# Lambda integration for GET schedule
resource "aws_api_gateway_integration" "lambda_get_schedule" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.schedule.id
  http_method = aws_api_gateway_method.get_schedule.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.schedule_lambda.invoke_arn
}
# Lambda integration for POST schedule
resource "aws_api_gateway_integration" "lambda_post_schedule" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  resource_id = aws_api_gateway_resource.schedule.id
  http_method = aws_api_gateway_method.post_schedule.http_method
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.schedule_lambda.invoke_arn
}

##################################################################
# API Gateway deployment
##################################################################
resource "aws_api_gateway_deployment" "crud_deployment" {
  rest_api_id = aws_api_gateway_rest_api.doggo-api.id
  triggers = {

    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.lambda_get_login.id,
      aws_api_gateway_integration.lambda_post_messages.id,
      aws_api_gateway_integration.lambda_get_messages.id,
      aws_api_gateway_integration.lambda_get_services.id,
      aws_api_gateway_integration.lambda_get_sitters.id,
      aws_api_gateway_integration.lambda_get_schedule.id,
      aws_api_gateway_integration.lambda_post_schedule.id,

      aws_api_gateway_method.get_login.id,
      aws_api_gateway_method.post_messages.id,
      aws_api_gateway_method.get_messages.id,
      aws_api_gateway_method.get_services.id,
      aws_api_gateway_method.get_sitters.id,
      aws_api_gateway_method.get_schedule.id,
      aws_api_gateway_method.post_schedule.id,

      aws_api_gateway_resource.login.id,
      aws_api_gateway_resource.messages.id,
      aws_api_gateway_resource.services.id,
      aws_api_gateway_resource.sitters.id,
      aws_api_gateway_resource.schedule.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
##################################################################
# API Gateway stage
##################################################################
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.crud_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.doggo-api.id
  stage_name    = "api"
}
##################################################################