module "cognito" {
  source            = "../../modules/cognito"
  name_prefix       = "${var.project_name}-${var.environment}"
  app_email_subject = "${var.project_name} - Verify your email"
}
