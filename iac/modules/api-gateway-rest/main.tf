resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.name_prefix}-api"
  description = "REST API for ${var.name_prefix}"

  body = templatefile("${path.module}/openapi.yaml.tftpl", {
    name_prefix = var.name_prefix
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.api.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.name_prefix
}
