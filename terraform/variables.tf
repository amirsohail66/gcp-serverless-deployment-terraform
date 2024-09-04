variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "credential_path" {
  description = "The path of the account credential"
  type        = string
}

variable "region" {
  description = "The region to deploy the resources."
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket to store the function code."
  type        = string
}

variable "local_directory" {
  description = "The local directory where the function code is stored."
  type        = string
}

variable "functions" {
  type = list(object({
    name        = string
    dir_name    = string
    entry_point = string
    memory      = string
  }))
  description = "List of functions to deploy"
}

variable "secret_names" {
  description = "List of secret names to be managed in Secret Manager."
  type        = list(string)
}

variable "secret_files" {
  description = "List of local secret files to upload to Secret Manager."
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment (e.g., STAGING, PRODUCTION)."
  type        = string
}

variable "service_account" {
  description = "Service account email for the Cloud Functions."
  type        = string
}