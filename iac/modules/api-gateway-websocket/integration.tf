resource "aws_apigatewayv2_integration" "integration_connect" {
  api_id             = aws_apigatewayv2_api.api_websocket.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.connect_lambda_invoke_arn
}

resource "aws_apigatewayv2_integration" "integration_disconnect" {
  api_id             = aws_apigatewayv2_api.api_websocket.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.disconnect_lambda_invoke_arn
}

resource "aws_apigatewayv2_integration" "integration_find_match" {
  api_id             = aws_apigatewayv2_api.api_websocket.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.find_match_lambda_invoke_arn
}

resource "aws_apigatewayv2_integration" "integration_forward_signal" {
  api_id             = aws_apigatewayv2_api.api_websocket.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = var.forward_signal_lambda_invoke_arn
}
