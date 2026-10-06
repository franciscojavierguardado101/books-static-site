# GCS bucket — mirrors the Books site as a backup on Google Cloud
resource "google_storage_bucket" "backup" {
  name                        = var.bucket_name
  location                    = var.location
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = true

  labels = {
    environment = var.environment
    project     = "books-static-site"
    purpose     = "website-backup"
  }
}
