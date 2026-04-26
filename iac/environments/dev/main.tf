module "cognito" {
  source            = "../../modules/cognito"
  name_prefix       = "${var.project_name}-${var.environment}"
  app_email_subject = "${var.project_name} - Verify your email"
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  name_prefix = "${var.project_name}-${var.environment}"
}

module "api_gateway_rest" {
  source      = "../../modules/api-gateway-rest"
  name_prefix = "${var.project_name}-${var.environment}"
}
