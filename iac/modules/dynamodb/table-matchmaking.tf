resource "aws_dynamodb_table" "matchmaking" {

  name         = "${var.name_prefix}-matchmaking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "targetLanguageShard"
  range_key    = "createdAt"

  attribute {
    name = "targetLanguageShard"
    type = "S"
  }
  attribute {
    name = "createdAt"
    type = "N"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}
