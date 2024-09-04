output "secret_manager_secrets" {
  description = "List of created secrets in Secret Manager."
  value       = module.secret_manager.secrets
}

output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = module.api_gateway.gateway_url
}