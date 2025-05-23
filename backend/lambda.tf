module "lambda_functions" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.2"

  for_each = local.lambda_functions

  create_function = true

  publish       = true
  function_name = "doggo-${each.key}"
  description   = "Lambda function for ${each.key}"
  handler       = each.value.handler
  runtime       = "python3.13"

  source_path = each.value.source_path

  tags = local.tags

  # Lambda Permissions for allowed triggers
  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.api.execution_arn}/*/*/*"
    }
  }
}

module "lambda_layer_local" {
  source = "terraform-aws-modules/lambda/aws"

  for_each = local.lambda_layers

  create_layer = true

  layer_name          = "doggo-${each.key}"
  description         = each.value.description
  compatible_runtimes = each.value.compatible_runtimes

  source_path = each.value.source_path
}