variable "service_name" {
  type        = string
  default     = "ecs-agent"
  description = "ECS name Agent"
}

variable "environment" {
  type        = string
  description = "Application environment."
}
