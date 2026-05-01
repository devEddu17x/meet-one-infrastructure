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
  default     = "meet-one"
}

variable "environment" {
  description = "Environment identifier for bootstrap resources"
  type        = string
  default     = "bootstrap"
}

variable "cloudflare_api_key" {
  description = "Cloudflare account API KEY"
  type        = string
  default     = null
}

# variable "cloudflare_account_id" {
#   description = "ID de la cuenta de Cloudflare"
#   type        = string
# }

# variable "cloudflare_account_email" {
#   description = "Email associated with the Cloudflare account"
#   type        = string
# }
