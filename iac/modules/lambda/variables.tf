variable "name_prefix" {
  description = "Prefix to be used in resource names (e.g., meet-one-dev)"
  type        = string
}

variable "lambdas" {
  description = "Lambda function configurations"
  type = map(object({
    handler     = string
    runtime     = string
    source_path = string
    environment = map(string)
    role_policy = string
    timeout     = optional(number, 3)
    memory_size = optional(number, 128)
  }))
}
