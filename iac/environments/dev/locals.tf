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
    "add_to_group" = {
      handler     = "index.handler"
      runtime     = "nodejs24.x"
      source_path = "../../../services/lambdas/cognito/post_confirmation_trigger"
      environment = {}
      timeout     = 5
      memory_size = 256
      role_policy = data.aws_iam_policy_document.add_to_group_policy.json
    }
    "connect" = {
      handler     = "index.handler"
      runtime     = "nodejs24.x"
      source_path = "../../../services/lambdas/connections/connect"
      environment = {
        CONNECTIONS_TABLE = module.dynamodb.dynamodb_connections_table_name
      }
      timeout     = 5
      memory_size = 256
      role_policy = data.aws_iam_policy_document.connect_policy.json
    }

    "disconnect" = {
      handler     = "index.handler"
      runtime     = "nodejs24.x"
      source_path = "../../../services/lambdas/connections/disconnect"
      environment = {
        CONNECTIONS_TABLE = module.dynamodb.dynamodb_connections_table_name
        MATCHMAKING_TABLE = module.dynamodb.dynamodb_matchmaking_table_name
      }
      timeout     = 5
      memory_size = 256
      role_policy = data.aws_iam_policy_document.disconnect_policy.json
    }

    "find_match" = {
      handler     = "index.handler"
      runtime     = "nodejs24.x"
      source_path = "../../../services/lambdas/matchmaking/find_match"
      environment = {
        CONNECTIONS_TABLE         = module.dynamodb.dynamodb_connections_table_name
        MATCHMAKING_TABLE         = module.dynamodb.dynamodb_matchmaking_table_name
        CLOUDFLARE_TURN_TOKEN_ID  = var.cloudflare_turn_token_id
        CLOUDFLARE_TURN_API_TOKEN = var.cloudflare_turn_api_token
      }
      timeout     = 7
      memory_size = 256
      role_policy = data.aws_iam_policy_document.find_match_policy.json
    }

    "forward_signal" = {
      handler     = "index.handler"
      runtime     = "nodejs24.x"
      source_path = "../../../services/lambdas/connections/foward-signal"
      environment = {}
      timeout     = 5
      memory_size = 256
      role_policy = data.aws_iam_policy_document.forward_signal_policy.json
    }
  }
}
