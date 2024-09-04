# Provider configurations
provider "google" {
  credentials = var.credential_path
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = var.credential_path
  project     = var.project_id
  region      = var.region
}

# Enable necessary APIs
resource "google_project_service" "secret_manager_api" {
  service = "secretmanager.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "api_gateway" {
  project = var.project_id
  service = "apigateway.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

# IAM role bindings
resource "google_project_iam_member" "project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "secret_manager_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "secret_manager_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "api_gateway_admin" {
  project = var.project_id
  role    = "roles/apigateway.admin"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "api_gateway_function_invoker" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "cloud_build_connection_admin" {
  project = var.project_id
  role    = "roles/cloudbuild.connectionAdmin"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "cloud_build_workerpool_user" {
  project = var.project_id
  role    = "roles/cloudbuild.workerPoolUser"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "datastore_owner" {
  project = var.project_id
  role    = "roles/datastore.owner"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "firebase_admin" {
  project = var.project_id
  role    = "roles/firebase.admin"
  member  = "serviceAccount:${var.service_account}"
}

# Modules
module "secret_manager" {
  source       = "./modules/secret_manager"
  secret_names = var.secret_names
  secret_files = var.secret_files
  environment  = var.environment

  depends_on = [google_project_service.secret_manager_api]
}

module "cloud_functions" {
  source          = "./modules/cloud_functions"
  bucket_name     = var.bucket_name
  local_directory = var.local_directory
  functions       = var.functions
  region          = var.region
  environment     = var.environment
  service_account = var.service_account
  project_id      = var.project_id
  secret_names    = var.secret_names

  depends_on = [
    google_project_iam_member.service_account_user,
    google_project_iam_member.secret_manager_accessor
  ]
}

module "api_gateway" {
  source                  = "./modules/api_gateway"
  project_id              = var.project_id
  region                  = var.region
  authentication_function = module.cloud_functions.function_urls["authentication"]
  chatgpt_function        = module.cloud_functions.function_urls["chatgpt"]
  service_account         = var.service_account

  depends_on = [
    google_project_service.api_gateway,
    google_project_iam_member.api_gateway_admin,
    google_project_iam_member.service_account_user,
    module.cloud_functions
  ]
}