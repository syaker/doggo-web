#################################################
# IAM role for Lambda
#################################################
resource "aws_iam_role" "lambda_role" {
  name = "crud_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
#################################################
## Lambda function
#################################################

# Lambda function login_lambda
resource "aws_lambda_function" "login_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "login_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"

  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Lambda function register_lambda
resource "aws_lambda_function" "register_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "register_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"

  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Lambda function service_lambda
resource "aws_lambda_function" "service_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "service_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Lambda function message_lambda
resource "aws_lambda_function" "message_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "message_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Lambda function sitters_lambda
resource "aws_lambda_function" "sitters_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "sitters_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# Lambda function schedule_lambda
resource "aws_lambda_function" "schedule_lambda" {
  filename          = "lambda_function.zip"
  function_name     = "schedule_lambda"
  role              = aws_iam_role.lambda_role.arn
  handler           = "index.handler"
  runtime           = "python3.9"
  source_code_hash = filebase64sha256("lambda_function.zip")
}
##################################################################
# Lambda permission for API Gateway
##################################################################
resource "aws_lambda_permission" "login_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "register_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.register_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "service_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.service_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "message_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.message_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "sitters_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sitters_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "schedule_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.schedule_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.doggo-api.execution_arn}/*/*"
}