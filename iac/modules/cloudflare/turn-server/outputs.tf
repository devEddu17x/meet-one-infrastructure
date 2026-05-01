output "cloudflare_turn_key_id" {
  value       = cloudflare_calls_turn_app.turn_server.uid
  description = "The Cloudflare Calls TURN App ID (UID)"
}

output "cloudflare_turn_key_secret" {
  value       = cloudflare_calls_turn_app.turn_server.key
  description = "The Bearer token secret for the TURN server"
  sensitive   = true
}
