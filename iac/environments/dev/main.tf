module "cognito" {
  source            = "../../modules/cognito"
  name_prefix       = "${var.project_name}-${var.environment}"
  app_email_subject = "${var.project_name} - Verify your email"
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  name_prefix = "${var.project_name}-${var.environment}"
}

module "lambda" {
  source      = "../../modules/lambda"
  name_prefix = "${var.project_name}-${var.environment}"
  lambdas     = local.lambdas_config
}

module "api_gateway_rest" {
  source                           = "../../modules/api-gateway-rest"
  name_prefix                      = "${var.project_name}-${var.environment}"
  create_profile_lambda_invoke_arn = module.lambda.lambda_invoke_arns["create_profile"]
  get_profile_lambda_invoke_arn    = module.lambda.lambda_invoke_arns["get_profile"]
}
