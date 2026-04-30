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

data "aws_iam_policy_document" "add_to_group_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cognito-idp:AdminAddUserToGroup",
      "dynamodb:GetItem",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*", "arn:aws:logs:*:*:*"]
  }
}


data "aws_iam_policy_document" "connect_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [module.dynamodb.dynamodb_connections_table_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "disconnect_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem"
    ]
    resources = [module.dynamodb.dynamodb_connections_table_arn, module.dynamodb.dynamodb_matchmaking_table_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "find_match_policy" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:UpdateItem",
    ]
    resources = [module.dynamodb.dynamodb_connections_table_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
    ]
    resources = [module.dynamodb.dynamodb_matchmaking_table_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "execute-api:ManageConnections"
    ]
    resources = ["arn:aws:execute-api:*:*:*/*/*/@connections/*"]
  }
}
