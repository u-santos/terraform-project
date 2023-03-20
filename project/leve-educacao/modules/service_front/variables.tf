variable "service_name" {
  description = "Name of Service"
}

variable "viewer_protocol_policy" {
  type        = string
  description = "Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  type        = list(string)
  description = "controla quais métodos HTTP processam e encaminham o CloudFront para seu bucket do Amazon S3 ou sua origem personalizada."
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  type        = list(string)
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods."
  default     = ["GET", "HEAD"]
}

variable "default_root_object" {
  type        = string
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = "index.html"
}

variable "path_pattern" {
  type        = string
  description = " The pattern (for example, images/*.jpg) that specifies which requests you want this cache behavior to apply to."
  default     = "/*"
}

variable "headers" {
  type        = list(string)
  default     = ["Origin"]
  description = "Specifies the Headers, if any, that you want CloudFront to vary upon for this cache behavior. Specify * to include all headers."
}

variable "domains_name" {
  type = object({
    domain_name : string
    subject_alternative_names : list(string)
  })
  description = "A domain name for which the certificate should be issued"
}

variable "environment" {
  type        = string
  description = "Application environment."
}

variable "extra_origins" {
  type        = list
  description = "Utilizado para incluir mais de uma"
  default     = []
}

variable "tags_distribution" {
  type    = string
  default = ""
}

variable "default_function_association" {
  description = "Define a function association for default cache behavior."
  default     = []
}
