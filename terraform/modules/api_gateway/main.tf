resource "google_api_gateway_api" "api" {
  provider = google-beta
  api_id   = "${var.project_id}-gateway"
  project  = var.project_id
}

resource "google_api_gateway_api_config" "api_config" {
  provider      = google-beta
  api           = google_api_gateway_api.api.api_id
  api_config_id = "${var.project_id}-gateway-config"
  project       = var.project_id

  openapi_documents {
    document {
      path     = "spec.yaml"
      contents = base64encode(templatefile("${path.module}/openapi_spec.yaml", {
        authentication_function = var.authentication_function
        chatgpt_function        = var.chatgpt_function
      }))
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gateway" {
  provider     = google-beta
  region       = var.region
  api_config   = google_api_gateway_api_config.api_config.id
  gateway_id   = "${var.project_id}-gateway"
  project      = var.project_id  # Add this line
  display_name = "API Gateway"
}