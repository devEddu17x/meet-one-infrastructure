output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_execution_arn" {
  description = "The Execution ARN of the API Gateway (used to grant permissions to Lambda)"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "api_invoke_url" {
  description = "The Invoke URL of the deployed API Gateway stage"
  value       = aws_api_gateway_stage.stage.invoke_url
}
