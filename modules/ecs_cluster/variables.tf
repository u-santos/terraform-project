variable "name" {
  type        = string
  description = "The name of the cluster"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "container_insights" {
  description = "Define if Container Insights is enabled"
  default     = "disabled"
}
