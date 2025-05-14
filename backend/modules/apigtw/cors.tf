#### OPTIONS - CORS - MOCK ####
resource "aws_api_gateway_method" "options_method" {
  count = var.create_rest_api && var.cors_enabled ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.rest_api[0].id
  resource_id   = aws_api_gateway_resource.resource[0].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  count = var.create_rest_api && var.cors_enabled ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  resource_id = aws_api_gateway_resource.resource[0].id
  http_method = aws_api_gateway_method.options_method[0].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    aws_api_gateway_method.options_method
  ]
}

resource "aws_api_gateway_integration" "options_integration" {
  count = var.create_rest_api && var.cors_enabled ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  resource_id = aws_api_gateway_resource.resource[0].id
  http_method = aws_api_gateway_method.options_method[0].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }

  depends_on = [
    aws_api_gateway_method.options_method
  ]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count = var.create_rest_api && var.cors_enabled ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  resource_id = aws_api_gateway_resource.resource[0].id
  http_method = aws_api_gateway_method.options_method[0].http_method
  status_code = aws_api_gateway_method_response.options_200[0].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = var.cors_allow_headers
    "method.response.header.Access-Control-Allow-Methods" = var.cors_allow_method
    "method.response.header.Access-Control-Allow-Origin"  = var.cors_allow_origins
  }

  response_templates = {
    "application/json" = <<EOF
    ""
    EOF
  }

  depends_on = [
    aws_api_gateway_method_response.options_200
  ]
}