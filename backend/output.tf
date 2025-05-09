# RDS MYSQL
output "db_endpoint" {
  value       = module.db.db_instance_endpoint
  description = "The endpoint of the RDS instance"
}

# API Gateway
output "api_url" {
  description = "URL de la API Gateway"
  value       = "https://${module.api.api_id}.execute-api.${var.region}.amazonaws.com/api"
}
output "api_arn" {
  description = "ARN de la API Gateway"
  value       = module.api.api_arn

}