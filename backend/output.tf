# RDS MYSQL
output "db_endpoint" {
  value       = module.db.db_instance_endpoint
  description = "The endpoint of the RDS instance"
}