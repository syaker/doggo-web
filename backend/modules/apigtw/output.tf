###################################################################
# Outputs
###################################################################

output "api_url" {
  description = "URL de la API Gateway"
  value       = "https://${aws_api_gateway_rest_api.apigtw.id}.execute-api.${var.region}.amazonaws.com/api"
}

output "api_id" {
  description = "ID de la API Gateway"
  value       = aws_api_gateway_rest_api.apigtw.id
}

output "api_stage_url" {
  description = "URL de acceso al stage"
  value       = "https://${aws_api_gateway_rest_api.apigtw.id}.execute-api.${var.region}.amazonaws.com/api"
}
output "api_arn" {
  description = "ARN de la API Gateway"
  value       = aws_api_gateway_rest_api.apigtw.arn
}