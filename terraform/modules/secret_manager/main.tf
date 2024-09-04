resource "google_secret_manager_secret" "secrets" {
  count       = length(var.secret_names)
  secret_id   = var.secret_names[count.index]
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secrets_versions" {
  count       = length(var.secret_names)
  secret      = google_secret_manager_secret.secrets[count.index].id
  secret_data = file(var.secret_files[count.index])
}

output "secrets" {
  value = google_secret_manager_secret.secrets[*].id
}