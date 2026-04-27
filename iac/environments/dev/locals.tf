data "aws_iam_policy_document" "create_profile_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [module.dynamodb.dynamodb_users_table_arn, "arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "get_profile_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [module.dynamodb.dynamodb_users_table_arn, "arn:aws:logs:*:*:*"]
  }
}

locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lambdas_config = {
    "create_profile" = {
      handler     = "index.handler",
      runtime     = "nodejs24.x",
      source_path = "../../../services/lambdas/users/create_profile"
      environment = {
        USERS_TABLE = module.dynamodb.dynamodb_users_table_arn
      }
      timeout     = 3
      memory_size = 256
      role_policy = data.aws_iam_policy_document.create_profile_policy.json
    }

    "get_profile" = {
      handler     = "index.handler",
      runtime     = "nodejs24.x",
      source_path = "../../../services/lambdas/users/get_profile"
      environment = {
        USERS_TABLE = module.dynamodb.dynamodb_users_table_arn
      }
      timeout     = 3
      memory_size = 256
      role_policy = data.aws_iam_policy_document.get_profile_policy.json
    }
  }
}
