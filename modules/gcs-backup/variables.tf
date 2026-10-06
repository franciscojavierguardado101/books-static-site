variable "bucket_name" {
  type        = string
  description = "GCS bucket name — must be globally unique across all of GCP"
}

variable "location" {
  type        = string
  description = "GCS bucket location"
  default     = "US"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "force_destroy" {
  type        = bool
  description = "Allow deletion even if the bucket has files in it"
  default     = false
}
