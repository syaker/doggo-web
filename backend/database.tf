module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "doggodb"

  engine            = "mysql"
  engine_version    = "8.4.4"
  instance_class    = "db.t3.small"
  allocated_storage = 10

  allow_major_version_upgrade = true
  publicly_accessible         = true

  db_name  = "doggodb"
  username = "admin"
  port     = "3306"

  manage_master_user_password         = true
  iam_database_authentication_enabled = true

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
  subnet_ids             = ["subnet-0618296973e109d84", "subnet-0de8fd05f46371b3e"]

  family = "mysql8.4"

  major_engine_version = "8.4"

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