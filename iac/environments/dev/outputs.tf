output "user_pool_id" {
  description = "ID del Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "user_pool_arn" {
  description = "ARN del Cognito User Pool"
  value       = module.cognito.user_pool_arn
}

output "user_pool_endpoint" {
  description = "Endpoint del Cognito User Pool"
  value       = module.cognito.user_pool_endpoint
}

output "frontend_client_id" {
  description = "Client ID del User Pool Client para el frontend"
  value       = module.cognito.frontend_client_id
}
