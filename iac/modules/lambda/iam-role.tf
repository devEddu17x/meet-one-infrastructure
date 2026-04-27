resource "aws_iam_role" "lambda_role" {
  for_each           = var.lambdas
  name               = "${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda_policy" {
  for_each = var.lambdas
  name     = "${each.key}-policy"
  role     = aws_iam_role.lambda_role[each.key].id
  policy   = each.value.role_policy
}
