# ./modules/rds/main.tf

variable "rds_security_group_id" {
  type = string
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_db_instance" "example-01" {
  allocated_storage = 20
  engine            = "postgres"
  #  engine_version                        = "5.7"
  instance_class             = "db.t3.micro"
  name                       = "example"
  username                   = "woofministrator"
  password                   = random_password.password.result
  auto_minor_version_upgrade = true
  availability_zone          = "us-east-2a"
  backup_retention_period    = 0
  deletion_protection        = false
  delete_automated_backups   = true
  # iam_database_authentication_enabled   = false
  identifier                   = "example-rds-db"
  multi_az                     = false
  performance_insights_enabled = false
  # performance_insights_retention_period = 0
  port                = 3306
  publicly_accessible = true
  skip_final_snapshot = true
  # storage_encrypted                     = false
  storage_type = "gp2"
  tags         = var.common_tags

  vpc_security_group_ids = [
    var.rds_security_group_id
  ]
  enabled_cloudwatch_logs_exports = [
    # "error",
    # "general",
    # "slowquery",
  ]
}

output "example-01-address" {
  value = aws_db_instance.example-01.address
}

output "example-01-port" {
  value = aws_db_instance.example-01.port
}

output "example-01-name" {
  value = aws_db_instance.example-01.name
}

output "example-01-username" {
  value = aws_db_instance.example-01.username
}

output "example-01-password" {
  value = aws_db_instance.example-01.password
}
