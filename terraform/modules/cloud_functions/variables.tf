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
}

variable "region" {
  description = "The region to deploy the functions."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., STAGING, PRODUCTION)."
  type        = string
}

variable "service_account" {
  description = "The service account email to use for the Cloud Functions"
  type        = string
}

variable "project_id" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "secret_names" {
  type        = list(string)
  description = "List of secret names"
}