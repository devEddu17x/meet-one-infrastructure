output "dynamodb_users_table_name" {
  description = "The name of the users table"
  value       = aws_dynamodb_table.users.name
}

output "dynamodb_users_table_arn" {
  description = "The ARN of the users table"
  value       = aws_dynamodb_table.users.arn
}

output "dynamodb_connections_table_name" {
  description = "The name of the connections table"
  value       = aws_dynamodb_table.connections.name
}

output "dynamodb_connections_table_arn" {
  description = "The ARN of the connections table"
  value       = aws_dynamodb_table.connections.arn
}

output "dynamodb_matchmaking_table_name" {
  description = "The name of the matchmaking table"
  value       = aws_dynamodb_table.matchmaking.name
}

output "dynamodb_matchmaking_table_arn" {
  description = "The ARN of the matchmaking table"
  value       = aws_dynamodb_table.matchmaking.arn
}
