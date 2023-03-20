resource "aws_db_parameter_group" "database" {
  name = var.db_parameter_group_name
  family = "postgres12"
  description = "Postgres personalized Parameter Group"

  parameter {
    name = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
  }

  parameter {
    name = "log_connections"
    value = "1"
  }

  parameter {
    name = "log_disconnections"
    value = "1"
  }

  parameter {
    name = "log_temp_files"
    value = "0"
  }

  parameter {
    name = "log_lock_waits"
    value = "1"
  }

  parameter {
    name = "log_statement"
    value = "all"
  }

  parameter {
    name = "rds.force_admin_logging_level"
    value = "debug5"
  }

  parameter {
    name = "statement_timeout"
    value = "60000"
  }
}

resource "aws_db_instance" "database" {
  availability_zone = "sa-east-1a"
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.tags.project
  identifier           = var.tags.Name
  username             = "root"
  password             = var.password
  publicly_accessible  = true
  deletion_protection  = true
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name = var.aws_db_subnet_group_id
  vpc_security_group_ids = [var.vpc_security_group_ids]
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  enabled_cloudwatch_logs_exports = ["postgresql"]
  tags = var.tags
  }
