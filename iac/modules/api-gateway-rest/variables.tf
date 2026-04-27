variable "name_prefix" {
  description = "Prefix to be used in resource names (e.g., meet-one-dev)"
  type        = string
}
variable "create_profile_lambda_invoke_arn" {
  description = "Create profile lambda ARN"
  type        = string
}
variable "get_profile_lambda_invoke_arn" {
  description = "Get profile lambda ARN"
  type        = string
}
