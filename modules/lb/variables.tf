variable "security_groups" {
  type = list(string)
  default = []
  description = "A list of security group IDs to assign to the LB. Only valid for Load Balancers of type"
}

variable "subnets" {
  type = list(string)
  default = []
  description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource."
}

variable "vpc_id" {
  type        = string
  description = "The identifier of the VPC in which to create the target group. Required when target_type is instance or ip. Does not apply when target_type is lambda."
}

variable "listener_priority" {
  description = "Priority set to Listener Rule"
  default     = null
}

variable "path_pattern" {
  description = "Path Pattern listerner rule"
  default     = ""
}

variable "service_name" {
  description = "Name of Service"
}

variable "environment" {
  type        = string
  description = "Application environment."
}
