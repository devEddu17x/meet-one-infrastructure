variable "name_prefix" {
  description = "Prefix used for naming user pool and groups"
  type        = string
}

variable "connect_lambda_invoke_arn" {
  description = "Connect lambda ARN"
  type        = string
}
