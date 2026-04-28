resource "aws_lambda_permission" "allow_cognito" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_names["add_to_group"]
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = module.cognito.user_pool_arn
}

resource "aws_lambda_permission" "apigw_invoke_connect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_names["connect"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${module.api_gateway_websocket.api_websocket_execution_arn}/*/*"
}
