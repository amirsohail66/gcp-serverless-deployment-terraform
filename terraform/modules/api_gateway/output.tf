output "gateway_url" {
  description = "The URL of the API Gateway"
  value       = google_api_gateway_gateway.gateway.default_hostname
}