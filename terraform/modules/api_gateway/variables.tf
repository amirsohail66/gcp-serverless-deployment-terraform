variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "region" {
  description = "The region to deploy the API Gateway."
  type        = string
}

variable "authentication_function" {
  description = "The URL of the authentication Cloud Function."
  type        = string
}

variable "chatgpt_function" {
  description = "The URL of the ChatGPT Cloud Function."
  type        = string
}

variable "service_account" {
  description = "The service account to be used by the API Gateway"
  type        = string
}