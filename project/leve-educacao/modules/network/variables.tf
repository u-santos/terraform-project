variable "default_tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "service_name" {
  type        = string
  description = "Varivel utilizada para retornar nome para o subnet-group do RDS"
}

variable "environment" {
  type        = string
  description = "Varivel utilizada para retornar nome para o subnet-group do RDS"
}

variable "aws_service_security_group_ids" {
  type        = list
  description = "The IDs from service security group to ingress on RDS cluster."
}

variable "list_port_service_container" {
  type        = list(number)
  description = "List of service ports to release in the load balancing security group"
}

variable "rds_port" {
  type        = number
  default     = 5432
  description = "Insert port RDS"
}
