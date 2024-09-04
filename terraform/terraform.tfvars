project_id        = "your-project-id"
credential_path   = "../path-to-owner-sa-key.json"
region            = "your-preferred-region"
bucket_name       = "your-unique-bucket-name"
environment       = "STAGING"  # or "PRODUCTION"
secret_names      = ["staging-env-vars1", "staging-firestore1"]
secret_files      = ["./secrets/staging-env-vars.json", "./secrets/staging-firestore.json"]
service_account   = "project-runner-sa@your-project-id.iam.gserviceaccount.com"
functions         = [
  {
    name        = "function1"
    dir_name    = "function2" //specify source code
    entry_point = "index"
    memory      = "1024Mi"
  },
  {
    name        = "function2"
    dir_name    = "function2" //specify source code
    entry_point = "index"
    memory      = "1024Mi"
  }
]
