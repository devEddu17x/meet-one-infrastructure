variable "name_prefix" {
  description = "Prefix used for naming user pool and groups"
  type        = string
}

variable "connect_lambda_invoke_arn" {
  description = "Connect lambda ARN"
  type        = string
}

variable "disconnect_lambda_invoke_arn" {
  description = "Disconnect lambda ARN"
  type        = string
}

variable "find_match_lambda_invoke_arn" {
  description = "Find Match lambda ARN"
  type        = string
}
