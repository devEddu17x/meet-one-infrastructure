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
