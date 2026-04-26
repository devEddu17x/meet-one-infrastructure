resource "aws_cognito_user_group" "user_group" {
  user_pool_id = aws_cognito_user_pool.pool.id
  name         = "public-user"
  description  = "Group for public users"
}

resource "aws_cognito_user_group" "moderator_group" {
  user_pool_id = aws_cognito_user_pool.pool.id
  name         = "moderator-user"
  description  = "Group for moderator users"
}
