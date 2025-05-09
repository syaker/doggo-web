module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  identifier        = var.rds_identifier
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage

  allow_major_version_upgrade = true
  publicly_accessible         = true

  db_name  = var.rds_db_name
  username = var.rds_username
  port     = var.rds_port

  manage_master_user_password = true

  vpc_security_group_ids = ["sg-07b6f0d852779c6d3"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval    = "30"
  monitoring_role_name   = "doggodb_monitoring_role"
  create_monitoring_role = true

  tags = {
    Project     = "dweb"
    Environment = "dev"
    Name        = "doggodb"
  }

  create_db_subnet_group = true
  subnet_ids             = ["subnet-0dfaf74a4495dfd9c", "subnet-0de8fd05f46371b3e"]

  family = var.rds_family

  major_engine_version = var.rds_major_engine_version

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}