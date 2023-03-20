resource "aws_db_parameter_group" "database" {
  name        = var.db_parameter_group_name
  family      = "aurora-postgresql12"
  description = "Postgres personalized Parameter Group"

  parameter {
    name  = "log_filename"
    value = "postgresql.log.%Y-%m-%d-%H"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_temp_files"
    value = "0"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "rds.force_admin_logging_level"
    value = "debug5"
  }

  parameter {
    name  = "statement_timeout"
    value = "60000"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.cluster_name}-aurora"
  master_username                 = "root"
  master_password                 = var.password
  engine                          = var.engine
  engine_version                  = var.engine_version
  backup_retention_period         = 35
  deletion_protection             = true
  final_snapshot_identifier       = var.cluster_name
  preferred_backup_window         = "21:00-22:00"
  preferred_maintenance_window    = var.preferred_maintenance_window
  db_subnet_group_name            = var.aws_db_subnet_group_id
  vpc_security_group_ids          = [var.vpc_security_group_ids]
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = var.tags
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                                 = var.instance_count
  identifier                            = "${var.cluster_name}-${count.index}"
  cluster_identifier                    = aws_rds_cluster.default.id
  instance_class                        = var.instance_class
  engine                                = aws_rds_cluster.default.engine
  engine_version                        = aws_rds_cluster.default.engine_version
  publicly_accessible                   = true
  tags                                  = var.tags
  db_parameter_group_name               = var.db_parameter_group_name
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  preferred_maintenance_window          = var.preferred_maintenance_window
  apply_immediately                     = true
  auto_minor_version_upgrade            = false
}
