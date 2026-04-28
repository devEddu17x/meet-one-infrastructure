output "api_websocket_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.api_websocket.id
}

output "api_websocket_execution_arn" {
  description = "The Execution ARN of the API Gateway (used to grant permissions to Lambda)"
  value       = aws_apigatewayv2_api.api_websocket.execution_arn
}

output "api_websocket_invoke_url" {
  description = "The Invoke URL of the deployed API Gateway stage"
  value       = aws_apigatewayv2_stage.stage.invoke_url
}
