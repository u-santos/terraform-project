variable "region" {
  type        = string
  description = "AWS region."
  default     = "sa-east-1"
}

variable "product" {
  type        = string
  description = "Desired name for product resources identification."
}

variable "service_name" {
  type        = string
  description = "Service name description."
}

variable "environment" {
  type        = string
  description = "Application environment."
}

variable "list_port_service_container" {
  type        = list(number)
  description = "List of service ports to release in the load balancing security group"
}

variable "ecr_image_count" {
  type        = number
  default     = 1
  description = "Number of images in ECR"
}

variable "rds_instance_class" {
  type        = string
  description = "Instance class for rds database."
}

variable "db_parameter_group_name" {
  type        = string
  description = "The name of the parameter group to associate with this DB instance."
}

variable "rds_engine" {
  type        = string
  description = "Engine for rds database."
}

variable "rds_engine_version" {
  type        = string
  description = "Engine version for rds database."
}

variable "rds_password" {
  type        = string
  description = "Password for rds database root user."
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "Allow auto destuction of database"
}

variable "rds_count" {
  type        = number
  description = "Instance count for rds cluster"
}

variable "rds_cluster_preferred_maintenance_window" {
  type        = string
  default     = "wed:01:00-wed:04:00"
  description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\". UTC"
}

variable "backup_retention_period" {
  type        = string
  description = "The days to retain backups for. Must be between 0 and 35. Must be greater than 0 if the database is used as a source for a Read Replica."
}

variable "backup_window" {
  type        = string
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: (09:46-10:16). Must not overlap with maintenance_window."
}

variable "tags_distribution" {
  type    = string
  default = ""
}

variable "rds_client_instance_class" {
  type        = string
  description = "Instance class for rds database."
}


variable "rds_client_password" {
  type        = string
  description = "Password for rds database root user."
}

variable "rds_allocated_storage" {
  type        = string
  description = "Allocated Storage for rds database."
}

variable "rds_instance_preferred_maintenance_window" {
  type        = string
  default     = "tue:01:00-tue:04:00"
  description = "The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\". UTC"
}

variable "cpu_api_course" {
  description = "Required vCPU units for the service"
  default     = 512
}

variable "memory_api_course" {
  description = "Required memory for the service"
  default     = 1024
}

variable "max_capacity_api_course" {
  description = "Max Capacity in Autoscaling"
  default     = 2
}

variable "host_api_course" {
  type = object({
    domain_name : string
    subject_alternative_names : list(string)
  })
  description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
}

# variable "host_leve_front" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "host_leve_admin" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "host_api_leve_client" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "host_api_file" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "host_api_support" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "host_api_exam" {
#   type = object({
#     domain_name : string
#     subject_alternative_names : list(string)
#   })
#   description = "Service URL to request the certificate manager and to point the CNAME to the Cloud Front"
# }

# variable "cpu_api_leve_client" {
#   description = "Required vCPU units for the service"
#   default     = 512
# }

# variable "memory_api_leve_client" {
#   description = "Required memory for the service"
#   default     = 1024
# }

# variable "max_capacity_api_leve_client" {
#   description = "Max Capacity in Autoscaling"
#   default     = 1
# }