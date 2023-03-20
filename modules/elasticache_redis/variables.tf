variable "resource" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}

variable "number_replicas" {
  type        = number
  description = "The number of cluster replicas"
}

variable "number_shards" {
  type        = number
  description = "The number of cluster shards."
}

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "subnet_ids" {
  type        = list
  description = "List of VPC Subnet IDs for the cache subnet group."
}

variable "vpc_id" {
  type        = string
  description = "VPC Id to associate with Redis ElastiCache."
}

variable "engine_version" {
  default     = "6.x"
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "port" {
  default     = 6379
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}

variable "maintenance_window" {
  default     = ""
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}

variable "snapshot_window" {
  default     = ""
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
}

variable "snapshot_retention_limit" {
  default     = 30
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
}

variable "automatic_failover_enabled" {
  default     = true
  type        = string
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails."
}

variable "at_rest_encryption_enabled" {
  default     = true
  type        = string
  description = "Whether to enable encryption at rest."
}

variable "transit_encryption_enabled" {
  default     = true
  type        = string
  description = "Whether to enable encryption in transit."
}

variable "apply_immediately" {
  default     = false
  type        = string
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window."
}

variable "family" {
  default     = "redis5.0"
  type        = string
  description = "The family of the ElastiCache parameter group."
}

variable "description" {
  default     = "ElastiCache Redis managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}

variable "parameter_group_name" {
  default     = ""
  type        = string
  description = "The name of the parameter group to associate with this replication group."
}

variable "tags" {
  default     = {}
  type        = map
  description = "A mapping of tags to assign to all resources."
}

variable "auth_token" {
  type        = string
  description = "A mapping of tags to assign to all resources."
}

variable "aws_service_security_group_ids" {
  type = list
  description = "The IDs from service security group to ingress on Redis."
}
