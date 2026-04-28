resource "aws_apigatewayv2_api" "api_websocket" {
  name                       = "${var.name_prefix}-websocket-api"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api_websocket.id
  name        = "${var.name_prefix}-websocket-stage"
  auto_deploy = true
}
