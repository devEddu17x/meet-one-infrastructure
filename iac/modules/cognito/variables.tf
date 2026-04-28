variable "name_prefix" {
  description = "Prefix used for naming user pool and groups"
  type        = string
}
variable "app_email_subject" {
  description = "Subject for email verification messages"
  type        = string
  default     = "meet-one"
}

variable "post_confirmation_lambda_arn" {
  description = "ARN of the Lambda function to invoke after user confirmation"
  type        = string
}
