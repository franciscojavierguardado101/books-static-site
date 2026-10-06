variable "environment" {
  type        = string
  description = "Environment name"
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the Books site S3 bucket — used to scope the IAM policy"
}
