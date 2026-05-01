resource "cloudflare_calls_turn_app" "turn_server" {
  account_id = var.cloudflare_account_id
  name       = "${var.name_prefix}-turn-server"
}
