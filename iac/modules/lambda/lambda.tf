data "archive_file" "lambda_zip" {
  for_each    = var.lambdas
  type        = "zip"
  source_dir  = each.value.source_path
  output_path = "${path.module}/${each.key}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each      = var.lambdas
  function_name = each.key
  filename      = data.archive_file.lambda_zip[each.key].output_path
  handler       = each.value.handler
  runtime       = each.value.runtime
  role          = aws_iam_role.lambda_role[each.key].arn
  environment {
    variables = each.value.environment
  }
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256
  timeout          = each.value.timeout
  memory_size      = each.value.memory_size
}
