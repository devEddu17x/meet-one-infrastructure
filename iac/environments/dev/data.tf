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

