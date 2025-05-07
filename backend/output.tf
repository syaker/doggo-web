output "api_url" {
  value       = "${aws_api_gateway_stage.stage.invoke_url}/login"
  description = "The URL of the API Gateway"
}

output "db_endpoint" {
  value       = module.db.db_instance_endpoint
  description = "The endpoint of the RDS instance"
}
