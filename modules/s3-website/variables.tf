variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket for the Books static site"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod)"
}
