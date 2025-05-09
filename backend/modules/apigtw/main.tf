###################################################################
# API Gateway
###################################################################
resource "aws_api_gateway_rest_api" "apigtw" {
  name        = var.api_name
  description = "API Gateway"
}

# Creación de recursos
resource "aws_api_gateway_resource" "resources" {
  for_each = local.resources

  rest_api_id = aws_api_gateway_rest_api.apigtw.id
  parent_id   = aws_api_gateway_rest_api.apigtw.root_resource_id
  path_part   = each.value.path_part
}

# Creación de métodos
resource "aws_api_gateway_method" "methods" {
  for_each = merge([for resource_name, resource in local.resources : 
    { for method_name, method in resource.methods : 
      "${resource_name}_${method_name}" => merge(method, { resource_key = resource_name }) 
    }
  ]...)

  rest_api_id   = aws_api_gateway_rest_api.apigtw.id
  resource_id   = aws_api_gateway_resource.resources[each.value.resource_key].id
  http_method   = each.value.http_method
  authorization = each.value.authorization
}

###################################################################
# Integración con Lambda
###################################################################
resource "aws_api_gateway_integration" "lambda_integrations" {
  for_each                = aws_api_gateway_method.methods
  
  rest_api_id             = aws_api_gateway_rest_api.apigtw.id
  resource_id             = aws_api_gateway_resource.resources[split("_", each.key)[0]].id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_functions["${split("_", each.key)[0]}"]}/invocations"
  
  depends_on = [aws_api_gateway_method.methods]
}
###################################################################
# Despliegue de la API Gateway
###################################################################
resource "aws_api_gateway_deployment" "apigtw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigtw.id
  triggers = {
    redeployment = sha1(jsonencode(concat(
      [for method in aws_api_gateway_method.methods : method.id],
      [for integration in aws_api_gateway_integration.lambda_integrations : integration.id],
      [for resource in aws_api_gateway_resource.resources : resource.id]
    )))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_integration.lambda_integrations]
}
###################################################################
# API Gateway Stage
###################################################################
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.apigtw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigtw.id
  stage_name    = "api"
}
###################################################################
