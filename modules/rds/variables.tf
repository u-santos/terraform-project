variable "aws_db_subnet_group_id" {
  type        = string
  description = "Subnet group id for RDS"
}

variable "vpc_security_group_ids" {
  type        = string
  description = "Security group for vpc"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}


variable "instance_class" {
  type        = string
  description = "Instance class for database"
}

variable "engine" {
  type        = string
  description = "Engine for rds database."
}

variable "engine_version" {
  type        = string
  description = "Engine version for rds database."
}

variable "password" {
  type        = string
  description = "Password for rds database root user."
}

variable "allocated_storage" {
  type        = string
  description = "Allocated Storage for rds database."
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Allow auto destuction of database"
}

variable "db_parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group to associate with the DB instance"
}

variable "backup_retention_period" {
  type        = string
  description = "The days to retain backups for. Must be between 0 and 35. Must be greater than 0 if the database is used as a source for a Read Replica."
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: (09:46-10:16). Must not overlap with maintenance_window."
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: (ddd:hh24:mi-ddd:hh24:mi). Ex: (Mon:00:00-Mon:03:00)."
}
