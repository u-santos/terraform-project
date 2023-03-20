variable "service_name" {
  description = "Name of Service"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "image_count" {
  type        = string
  description = "Number of docker images kept by ecr"
}

variable "aws_ecs_cluster_id" {
  type        = string
  description = "ECS cluster id for service"
}

variable "health_check_grace_period" {
  default     = 300
}

variable "min_capacity" {
  description = "Min Capacity in Autoscaling"
  default     = 1
}

variable "max_capacity" {
  description = "Max Capacity in Autoscaling"
  default     = 1
}

variable "target_value" {
  description = "Target Value in Autoscaling"
  default     = 60
}

variable "scale_in_cooldown" {
  default     = 120
}

variable "scale_out_cooldown" {
  default     = 120
}

variable "alarm_request_count" {
  description = "Value for number of Request is trigger alarm"
  default     = 1000
}

variable "aws_ecs_cluster_main_name" {
  type        = string
}

variable "metric_type" {
  description = "Metric Type in Autoscaling"
  default     = "ECSServiceAverageCPUUtilization"
}

variable "aws_all_subnet_ids" {
  description     = "All subnet IDs"
}

variable "product" {
  type = string
}

variable "environment" {
  description = "Which environment (dev, staging, production, etc) this group of machines is for"
}

variable "image_tag" {
  description = "Tag version from docker image"
  default     = "latest"
}

variable "cpu" {
  description = "Required vCPU units for the service"
  default     = 256
}

variable "memory" {
  description = "Required memory for the service"
  default     = 512
}

variable "task_environment" {
  description = "A map of environment variables configured on the primary container"
  type        = map(string)
  default     = {}
}

variable "task_secret" {
  description = "A map of secret environment variables configured on the container"
  type        = map(string)
  default     = {}
}

variable "port" {
  description = "A published port for the ECS task"
}

variable "aws_iam_role_arn" {
  description = "Arn for IAM role"
}

variable "aws_vpc_main_id" {
  description = "VPC ID."
}

variable "tg_interval" {
  description = "Interval HealthCheck"
  default     = 30
}

variable "tg_path" {
  description = "Path HealthCheck"
  default     = "/status"
}

variable "tg_timeout" {
  description = "Timeout HealthCheck"
  default     = 5
}

variable "tg_matcher" {
  description = "Matcher HealthCheck"
  default     = "200-299"
}

variable "tg_healthy_threshold" {
  description = "Healthy Threshold HealthCheck"
  default     = 5
}

variable "tg_unhealthy_threshold" {
  description = "Unhealthy Threshold HealthCheck"
  default     = 2
}

variable "vpc_id" {
  type        = string
  description = "The identifier of the VPC in which to create the target group. Required when target_type is instance or ip. Does not apply when target_type is lambda."
}

variable "aws_lb_arn" {
  description = "The arn Load Balance."
}

variable "viewer_protocol_policy" {
  type = string
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
  default = "redirect-to-https"
}

variable "allowed_methods" {
  type = list(string)
  description = "controla quais métodos HTTP processam e encaminham o CloudFront para seu bucket do Amazon S3 ou sua origem personalizada."
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  type = list(string)
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods."
  default =  ["GET", "HEAD"]
}

variable "default_root_object" {
  type = string
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default = ""
}

variable "aws_lb_dns" {
  type = string
  description = "Load balancer cluster DNS for CloudFront Origin"
}

variable "aws_lb_id" {
  type = string
  description = "Load balancer cluster ID for CloudFront Origin"
}

variable "headers" {
  type = list(string)
  default = ["*"]
  description = "Specifies the Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers."
}

variable "query_string" {
  default = true
}

variable "cookies_forward" {
  default = "all"
}

variable "web_acl_id" {
  default = null
}

variable "extra_behaviors" {
  type = list
  default = []
}

variable "min_ttl" {
  default = 0
}

variable "default_ttl" {
  default = 3600
}

variable "max_ttl" {
  default = 86400
}

variable "domains_name" {
  type = object({
    domain_name: string
    subject_alternative_names: list(string)
  })
}

variable "execution_role_arn" {
  type = string
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume."
  default = ""
}

variable "rds_sg_id" {
  type = string
  description = "Allow incoming database connections."
  default = ""
}

variable "circuit_breaker_deployment_enabled" {
  type        = bool
  description = "Whether to enable the deployment circuit breaker logic for the service"
  default     = true
}

variable "circuit_breaker_rollback_enabled" {
  type        = bool
  description = "Whether to enable Amazon ECS to roll back the service if a service deployment fails"
  default     = true
}

variable "allow_origin_req" {
  type = list(string)
  description = "(Optional) Object that contains an attribute items that contains a list of origins that CloudFront can use as the value for the Access-Control-Allow-Origin HTTP response header."
  default =  ["*"]
}
