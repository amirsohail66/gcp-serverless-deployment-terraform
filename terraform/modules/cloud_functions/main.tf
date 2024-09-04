resource "google_storage_bucket" "function_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true
}

resource "random_id" "tmp_dir" {
  byte_length = 8
}

# Create ZIP files for each function
resource "null_resource" "zip_functions" {
  count = length(var.functions)

  provisioner "local-exec" {
    command = <<EOT
      TMPDIR=$(mktemp -d /tmp/function_${random_id.tmp_dir.hex}.XXXXXX) && \
      cd ${var.local_directory} && \
      zip -r $TMPDIR/${var.functions[count.index].name}function.zip shared -x "*/node_modules/*" "*/package-lock.json" "*/.env" && \
      cd ${var.functions[count.index].dir_name} && \
      zip -r $TMPDIR/${var.functions[count.index].name}function.zip . -x "*.zip" "node_modules/*" "package-lock.json" ".env" && \
      cd .. && \
      gsutil cp $TMPDIR/${var.functions[count.index].name}function.zip gs://${google_storage_bucket.function_bucket.name}/ && \
      rm -rf $TMPDIR
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Deploy functions
resource "google_cloudfunctions2_function" "function" {
  count    = length(var.functions)
  name     = var.functions[count.index].name
  location = var.region

  build_config {
    runtime     = "nodejs20"
    entry_point = var.functions[count.index].entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = "${var.functions[count.index].name}function.zip"
      }
    }
  }

  service_config {
    available_memory      = var.functions[count.index].memory
    service_account_email = var.service_account
    environment_variables = {
      STAGING_ENV_FILE_PATH                = "projects/${var.project_id}/secrets/${var.secret_names[0]}/versions/latest"
      STAGING_SERVICE_ACCOUNT_FILE_PATH    = "projects/${var.project_id}/secrets/${var.secret_names[1]}/versions/latest"
      PRODUCTION_ENV_FILE_PATH             = "projects/${var.project_id}/secrets/production-env-vars/versions/latest"
      PRODUCTION_SERVICE_ACCOUNT_FILE_PATH = "projects/${var.project_id}/secrets/production-firestore/versions/latest"
      ENVIRONMENT                          = var.environment
    }
  }

  depends_on = [null_resource.zip_functions]
}

resource "google_cloudfunctions2_function_iam_member" "function_invoker" {
  count          = length(var.functions)
  project        = google_cloudfunctions2_function.function[count.index].project
  location       = google_cloudfunctions2_function.function[count.index].location
  cloud_function = google_cloudfunctions2_function.function[count.index].name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${var.service_account}"
}