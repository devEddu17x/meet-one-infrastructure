resource "aws_apigatewayv2_integration" "integration_connect" {
  api_id             = aws_apigatewayv2_api.api_websocket.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.connect_lambda_invoke_arn
}
