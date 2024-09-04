variable "secret_names" {
  description = "List of secret names to be created in Secret Manager."
  type        = list(string)
}

variable "secret_files" {
  description = "List of file paths containing the secret data."
  type        = list(string)
}

variable "environment" {
  description = "The environment for which the secrets are being managed."
  type        = string
}