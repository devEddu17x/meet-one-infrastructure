# resource "aws_apigatewayv2_route" "route_default" {
#   api_id    = aws_apigatewayv2_api.api_websocket.id
#   route_key = "$default"
# }

resource "aws_apigatewayv2_route" "route_connect" {
  api_id    = aws_apigatewayv2_api.api_websocket.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.integration_connect.id}"
}

resource "aws_apigatewayv2_route" "route_disconnect" {
  api_id    = aws_apigatewayv2_api.api_websocket.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.integration_disconnect.id}"
}
