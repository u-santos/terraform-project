variable "tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "aws_db_subnet_group_id" {
  type        = string
  description = "Subnet group id for RDS"
}

variable "vpc_security_group_ids" {
  type        = string
  description = "Security group for vpc"
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

variable "skip_final_snapshot" {
  type        = bool
  description = "Allow auto destuction of database"
}

variable "instance_count" {
  type        = number
  description = "Instance count for rds cluster"
}

variable "cluster_name" {
  type        = string
  description = "Instance count for rds cluster"
}

variable "preferred_maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\". UTC"
}

variable "db_parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group to associate with the DB instance"
}
