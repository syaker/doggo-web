output "execution_arn" {
  value = try(aws_api_gateway_rest_api.rest_api[0].execution_arn, "")
}

output "api_id" {
  value = try(aws_api_gateway_rest_api.rest_api[0].id, "")
}

output "api_root_resource_id" {
  value = try(aws_api_gateway_rest_api.rest_api[0].root_resource_id, "")
}

output "stage_arn" {
  value = try(aws_api_gateway_stage.api_stage[0].arn, "")
}

output "cloudfront_domain_name" {
  value = try(aws_api_gateway_domain_name.api_domain_namee[0].cloudfront_domain_name, "")
}

output "cloudfront_zone_id" {
  value = try(aws_api_gateway_domain_name.api_domain_namee[0].cloudfront_zone_id, "")
}

output "regional_domain_name" {
  value = try(aws_api_gateway_domain_name.api_domain_namee[0].regional_domain_name, "")
}

output "regional_zone_id" {
  value = try(aws_api_gateway_domain_name.api_domain_namee[0].regional_zone_id, "")
}

output "domain_name" {
  value = try(aws_api_gateway_domain_name.api_domain_namee[0].domain_name, "")
}
