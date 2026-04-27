locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  lambdas_config = {
    "create_profile" = {
      handler     = "index.js",
      runtime     = "nodejs24.x",
      source_path = "../../../services/lambdas/users/create_profile"
      environment = {
        USERS_TABLE = module.dynamodb.dynamodb_users_table_arn
      }
      timeout     = 3
      memory_size = 256
      role_policy = jsonencode({
        version = "2012-10-17"
        statement = [
          { Effect   = "Allow"
            Action   = ["dynamodb:PutItem"]
            Resource = module.dynamodb.dynamodb_users_table_arn
          }
        ]
      })
    }

    "get_profile" = {
      handler     = "index.js",
      runtime     = "nodejs24.x",
      source_path = "../../../services/lambdas/users/get_profile"
      environment = {
        USERS_TABLE = module.dynamodb.dynamodb_users_table_arn
      }
      timeout     = 3
      memory_size = 256
      role_policy = jsonencode({
        version = "2012-10-17"
        statement = [
          { Effect   = "Allow"
            Action   = ["dynamodb:GetItem"]
            Resource = module.dynamodb.dynamodb_users_table_arn
          }
        ]
      })
    }
  }
}
