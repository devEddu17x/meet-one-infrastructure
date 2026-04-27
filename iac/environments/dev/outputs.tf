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

output "dynamodb_users_table_name" {
  description = "The name of the users table"
  value       = module.dynamodb.dynamodb_users_table_name
}

output "dynamodb_users_table_arn" {
  description = "The ARN of the users table"
  value       = module.dynamodb.dynamodb_users_table_arn
}

output "dynamodb_connections_table_name" {
  description = "The name of the connections table"
  value       = module.dynamodb.dynamodb_connections_table_name
}

output "dynamodb_connections_table_arn" {
  description = "The ARN of the connections table"
  value       = module.dynamodb.dynamodb_connections_table_arn
}

output "dynamodb_matchmaking_table_name" {
  description = "The name of the matchmaking table"
  value       = module.dynamodb.dynamodb_matchmaking_table_name
}

output "dynamodb_matchmaking_table_arn" {
  description = "The ARN of the matchmaking table"
  value       = module.dynamodb.dynamodb_matchmaking_table_arn
}

output "lambda_arns" {
  value = module.lambda.lambda_arns
}
output "lambda_names" {
  value = module.lambda.lambda_names
}

output "api_id" {
  description = "The ID of the API Gateway"
  value       = module.api_gateway_rest.api_id
}

output "api_execution_arn" {
  description = "The Execution ARN of the API Gateway (used to grant permissions to Lambda)"
  value       = module.api_gateway_rest.api_execution_arn
}

output "api_invoke_url" {
  description = "The Invoke URL of the deployed API Gateway stage"
  value       = module.api_gateway_rest.api_invoke_url
}
