locals {
  create_rest_api             = var.create_rest_api
  create_rest_api_policy      = local.create_rest_api && var.rest_api_policy != null
  vpc_link_enabled            = local.create_rest_api && length(var.private_link_target_arns) > 0
  log_group_arn               = local.create_cloudwatch_log_group ? aws_cloudwatch_log_group.log_group[0].arn : null
  create_cloudwatch_log_group = local.create_rest_api && var.logging_level != "OFF"
  create_api_integration      = local.create_rest_api && var.create_api_integration
  create_api_authorizer       = local.create_rest_api && var.create_api_authorizer
  create_api_domain_name      = local.create_rest_api && var.domain_name != ""
  create_request_validator    = local.create_rest_api && var.create_request_validator
}

data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "rest_api" {
  count              = local.create_rest_api ? 1 : 0
  name               = var.rest_api_name
  body               = var.openapi_config != null ? jsonencode(var.openapi_config) : null
  binary_media_types = var.binary_media_types
  endpoint_configuration {
    types = [var.endpoint_type]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(var.resource_tags_mandatory, var.tags, { Name : var.rest_api_name })
}

resource "aws_api_gateway_rest_api_policy" "rest_api_policy" {
  count       = var.create_rest_api && local.create_rest_api_policy ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  policy      = var.rest_api_policy
}

resource "aws_api_gateway_deployment" "api_deployment" {
  count             = var.create_rest_api && local.create_rest_api && var.create_deployment_enabled ? 1 : 0
  rest_api_id       = aws_api_gateway_rest_api.rest_api[0].id
  stage_description = timestamp()
  description       = "Deployed at ${timestamp()}"

  triggers = {
    redeployment = var.openapi_config != null ? sha1(jsonencode(aws_api_gateway_rest_api.rest_api[0].body)) : sha1(jsonencode([
      aws_api_gateway_resource.resource,
      aws_api_gateway_method.method,
      aws_api_gateway_integration.integration,
      var.uri,
      var.timeout_milliseconds,
      var.cors_allow_headers,
      var.cors_allow_method,
      var.cors_allow_origins]
    ))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  count       = var.create_rest_api && local.vpc_link_enabled ? 1 : 0
  name        = var.api_vpclink_name
  target_arns = var.private_link_target_arns
  tags        = merge(var.resource_tags_mandatory, var.tags, { Name : var.api_vpclink_name })
}

resource "aws_api_gateway_stage" "api_stage" {
  #checkov:skip=CKV2_AWS_29:WAF association is made in WAF module.
  #checkov:skip=CKV_AWS_120:Skip approved by IT Security Team.
  count                 = var.create_rest_api && var.stage != "" && var.create_stage_enabled ? 1 : 0
  deployment_id         = aws_api_gateway_deployment.api_deployment[0].id
  rest_api_id           = aws_api_gateway_rest_api.rest_api[0].id
  stage_name            = var.stage
  xray_tracing_enabled  = var.xray_tracing_enabled
  cache_cluster_enabled = var.cache_cluster_enabled
  cache_cluster_size    = var.cache_cluster_size
  tags                  = merge(var.resource_tags_mandatory, var.tags, { Name : var.stage })
  variables = {
    vpc_link_id = local.vpc_link_enabled ? aws_api_gateway_vpc_link.vpc_link[0].id : var.api_vpclink_id
    lb_name_dns = var.stage_variable_lb
  }

  dynamic "access_log_settings" {
    for_each = local.create_cloudwatch_log_group ? [1] : []
    content {
      destination_arn = local.log_group_arn
      format          = replace(file("${path.module}/template/logformat.json"), "\n", "")
    }
  }
  depends_on = [aws_api_gateway_account.api_account]
}

resource "aws_api_gateway_resource" "resource" {
  count       = var.create_rest_api && length(var.path_parts) > 0 ? length(var.path_parts) : 0
  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  parent_id   = aws_api_gateway_rest_api.rest_api[0].root_resource_id
  path_part   = element(var.path_parts, count.index)
  depends_on  = [aws_api_gateway_rest_api.rest_api]
}

resource "aws_api_gateway_model" "model_api" {
  count        = var.create_rest_api && length(var.http_methods) > 0 ? length(var.http_methods) : 0
  rest_api_id  = aws_api_gateway_rest_api.rest_api[0].id
  name         = element(var.model_api_name, count.index)
  description  = element(var.model_api_description, count.index)
  content_type = element(var.model_api_content_type, count.index)

  schema = <<EOF
{
  "type": "object"
}
EOF
}

resource "aws_api_gateway_authorizer" "authorizer" {
  count                            = var.create_rest_api && local.create_api_authorizer ? 1 : 0
  rest_api_id                      = aws_api_gateway_rest_api.rest_api[0].id
  name                             = var.authorizer_names
  authorizer_uri                   = var.authorizer_uri
  authorizer_credentials           = var.authorizer_credentials
  authorizer_result_ttl_in_seconds = var.authorizer_result_ttl_in_seconds
  identity_source                  = var.identity_sources
  type                             = var.authorizer_types
  identity_validation_expression   = var.identity_validation_expressions
  provider_arns                    = var.provider_arns
}

resource "aws_api_gateway_request_validator" "request_validator" {
  count                       = var.create_rest_api && local.create_request_validator ? 1 : 0
  name                        = var.request_validator_name
  rest_api_id                 = aws_api_gateway_rest_api.rest_api[0].id
  validate_request_body       = var.validate_request_body
  validate_request_parameters = var.validate_request_parameters
}

resource "aws_api_gateway_method" "method" {
  count                = var.create_rest_api && length(var.http_methods) > 0 ? length(var.http_methods) : 0
  rest_api_id          = aws_api_gateway_rest_api.rest_api[0].id
  resource_id          = aws_api_gateway_resource.resource.*.id[count.index]
  http_method          = element(var.http_methods, count.index)
  authorization        = length(var.authorizations) > 0 ? element(var.authorizations, count.index) : "NONE"
  authorization_scopes = length(var.authorization_scopes) > 0 ? element(var.authorization_scopes, count.index) : null
  authorizer_id        = length(var.authorizer_ids) > 0 ? element(var.authorizer_ids, count.index) : (local.create_api_authorizer ? aws_api_gateway_authorizer.authorizer[0].id : null)
  api_key_required     = length(var.api_key_requireds) > 0 ? element(var.api_key_requireds, count.index) : null
  request_models       = length(var.request_models) > 0 ? element(var.request_models, count.index) : ({ "application/json" : element(var.model_api_name, count.index) })
  request_parameters   = length(var.request_parameters) > 0 ? element(var.request_parameters, count.index) : {}
  request_validator_id = length(var.request_validator_ids) > 0 ? element(var.request_validator_ids, count.index) : (local.create_request_validator ? aws_api_gateway_request_validator.request_validator[0].id : null)
}

resource "aws_api_gateway_integration" "integration" {
  count                   = var.create_rest_api && local.create_api_integration ? length(aws_api_gateway_method.method.*.id) : 0
  rest_api_id             = aws_api_gateway_rest_api.rest_api[0].id
  resource_id             = aws_api_gateway_resource.resource.*.id[count.index]
  http_method             = aws_api_gateway_method.method.*.http_method[count.index]
  integration_http_method = length(var.integration_http_methods) > 0 ? element(var.integration_http_methods, count.index) : null
  type                    = length(var.integration_types) > 0 ? element(var.integration_types, count.index) : "AWS_PROXY"
  connection_type         = length(var.connection_types) > 0 ? element(var.connection_types, count.index) : "INTERNET"
  connection_id           = length(var.connection_ids) > 0 ? element(var.connection_ids, count.index) : (local.vpc_link_enabled ? aws_api_gateway_vpc_link.vpc_link[0].id : try(var.api_vpclink_id, null))
  uri                     = length(var.uri) > 0 ? element(var.uri, count.index) : ""
  credentials             = length(var.credentials) > 0 ? element(var.credentials, count.index) : ""
  request_parameters      = length(var.integration_request_parameters) > 0 ? element(var.integration_request_parameters, count.index) : {}
  request_templates       = length(var.request_templates) > 0 ? element(var.request_templates, count.index) : {}
  passthrough_behavior    = length(var.passthrough_behaviors) > 0 ? element(var.passthrough_behaviors, count.index) : null
  cache_key_parameters    = length(var.cache_key_parameters) > 0 ? element(var.cache_key_parameters, count.index) : []
  cache_namespace         = length(var.cache_namespaces) > 0 ? element(var.cache_namespaces, count.index) : ""
  content_handling        = length(var.content_handlings) > 0 ? element(var.content_handlings, count.index) : null
  timeout_milliseconds    = length(var.timeout_milliseconds) > 0 ? element(var.timeout_milliseconds, count.index) : 29000
  depends_on              = [aws_api_gateway_method.method]
}

resource "aws_api_gateway_domain_name" "api_domain_namee" {
  count                    = var.create_rest_api && local.create_api_domain_name ? 1 : 0
  certificate_arn          = var.domain_endpoint_type == "EDGE" ? var.certificate_arn : null
  regional_certificate_arn = var.domain_endpoint_type == "REGIONAL" ? var.certificate_arn : null
  security_policy          = var.api_domain_name_security_policy
  domain_name              = var.domain_name
  endpoint_configuration {
    types = [var.domain_endpoint_type]
  }
  tags = merge(var.resource_tags_mandatory, var.tags, { Name : var.domain_name })
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count       = var.create_rest_api && local.create_api_domain_name ? 1 : 0
  api_id      = aws_api_gateway_rest_api.rest_api[0].id
  stage_name  = var.create_stage_enabled ? aws_api_gateway_stage.api_stage[0].stage_name : var.stage
  domain_name = aws_api_gateway_domain_name.api_domain_namee[0].domain_name
}

# API Gateway Key

resource "aws_api_gateway_api_key" "api_key" {
  for_each    = { for k, v in var.api-gateway-key : k => v if var.create_rest_api && contains(keys(v), "api_key_name") }
  name        = try(each.value.api_key_name, null)
  description = try(each.value.api_key_description, null)
  enabled     = try(each.value.api_key_enabled, null)
  value       = try(each.value.api_key_value, null)
  tags        = merge(var.resource_tags_mandatory, var.tags, { Name : try(each.value.api_key_name, null) })
}

resource "aws_api_gateway_usage_plan_key" "main" {
  for_each      = { for k, v in var.api-gateway-key : k => v if var.create_rest_api && contains(keys(v), "api_key_name") }
  key_id        = aws_api_gateway_api_key.api_key[each.key].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan[0].id
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  count        = var.create_rest_api && var.usage_plan_name != "" ? 1 : 0
  name         = var.usage_plan_name
  description  = var.usage_plan_description
  product_code = var.usage_plan_product_code

  dynamic "api_stages" {
    for_each = aws_api_gateway_stage.api_stage
    content {
      api_id = aws_api_gateway_rest_api.rest_api[0].id
      stage  = api_stages.value.stage_name
    }
  }

  dynamic "quota_settings" {
    for_each = var.quota_settings
    content {
      limit  = quota_settings.value.limit
      offset = quota_settings.value.offset
      period = quota_settings.value.period
    }
  }

  dynamic "throttle_settings" {
    for_each = var.throttle_settings
    content {
      burst_limit = throttle_settings.value.burst_limit
      rate_limit  = throttle_settings.value.rate_limit
    }
  }
  tags = merge(var.resource_tags_mandatory, var.tags, { Name : var.usage_plan_name })
}


#Logging, metrics and tracing levels

resource "aws_api_gateway_method_settings" "api_method" {
  #checkov:skip=CKV_AWS_225:Skip approved by IT Security Team.
  count       = var.openapi_config != null ? 1 : var.create_rest_api && length(var.http_methods) > 0 ? length(var.http_methods) : 0
  rest_api_id = aws_api_gateway_rest_api.rest_api[0].id
  stage_name  = aws_api_gateway_stage.api_stage[0].stage_name
  method_path = "*/*"

  settings {
    metrics_enabled        = var.metrics_enabled
    logging_level          = var.logging_level
    data_trace_enabled     = var.data_trace_enabled
    throttling_burst_limit = var.default_throttling_burst_limit
    throttling_rate_limit  = var.default_throttling_rate_limit
    caching_enabled        = var.caching_enabled
    cache_data_encrypted   = var.cache_data_encrypted
  }
}

resource "aws_api_gateway_account" "api_account" {
  count               = var.create_rest_api && local.create_cloudwatch_log_group ? 1 : 0
  cloudwatch_role_arn = aws_iam_role.apigateway_cloudwatch[0].arn
  depends_on          = [aws_iam_role.apigateway_cloudwatch]
}

# CloudWatch Log Group

resource "aws_cloudwatch_log_group" "log_group" {
  count             = var.create_rest_api && local.create_cloudwatch_log_group ? 1 : 0
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  tags              = merge(var.resource_tags_mandatory, var.tags, { Name : var.cloudwatch_log_group_name })
  depends_on        = [aws_iam_role.apigateway_cloudwatch]
}

# Role for Cloudwatch Log
resource "aws_iam_role" "apigateway_cloudwatch" {
  count = var.create_rest_api && local.create_cloudwatch_log_group ? 1 : 0
  name  = "${data.aws_region.current.name}-${var.rest_api_name}-apigateway-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = merge(var.resource_tags_mandatory, var.tags, { Name : "${data.aws_region.current.name}-${var.rest_api_name}-apigateway-role" })
}

resource "aws_iam_role_policy" "apigateway_cloudwatch" {
  count = var.create_rest_api && local.create_cloudwatch_log_group ? 1 : 0
  name  = "${data.aws_region.current.name}-${var.rest_api_name}-apigateway-policy"
  role  = aws_iam_role.apigateway_cloudwatch[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}