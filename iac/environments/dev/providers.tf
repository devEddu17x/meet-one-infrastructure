provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = local.default_tags
  }
}

# provider "cloudflare" {
#   email   = var.cloudflare_account_email
#   api_key = var.cloudflare_api_key
# }
