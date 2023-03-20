variable "resource" {
  type        = string
  default     = ""
  description = "Full resource name to identify product, service and environment."
}

variable "public" {
  type        = bool
  default     = true
  description = "Bucket rule. True to be public and false to be private."
}

variable "restrict_acess" {
  type        = bool
  default     = false
  description = "Bucket rule. True to be public and false to be private."
}

variable "ignore_public_acls" {
  type        = bool
  default     = false
  description = "Bucket rule. True to be public and false to be private."
}

variable "block_public_policy" {
  type        = bool
  default     = false
  description = "Bucket rule. True to be public and false to be private."
}

variable "block_public_acls" {
  type        = bool
  default     = false
  description = "Bucket rule. True to be public and false to be private."
}

variable "policy_path" {
  type        = string
  description = "Path to the Network Load Balancer policy."
}

variable "policy_variables" {
  type        = map
  default     = {}
  description = "Variables to be inserted to the policy template."
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags definition."
}

variable "allowed_headers" {
  type        = list(string)
  default     = [""]
  description = ""
}
variable "allowed_methods" {
  type        = list(string)
  default     = [""]
  description = ""
}
variable "allowed_origins" {
  type        = list(string)
  default     = [""]
  description = ""
}
variable "expose_headers" {
  type        = list(string)
  default     = []
  description = ""
}
variable "max_age_seconds" {
  type        = number
  default     = 0
  description = ""
}
