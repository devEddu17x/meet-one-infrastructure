variable "aws_region" {
  description = "AWS region where bootstrap resources are provisioned"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS shared config profile name (useful for AWS SSO)"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Project identifier used in naming and tagging"
  type        = string
  default     = "galaxy-morph"
}

variable "environment" {
  description = "Environment identifier for bootstrap resources"
  type        = string
  default     = "bootstrap"
}

variable "cloudflare_api_token" {
  description = "Cloudflare account API TOKEN"
  type        = string
  default     = null
}
