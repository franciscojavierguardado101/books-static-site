variable "environment" {
  type        = string
  description = "Environment name"
}

variable "s3_bucket_id" {
  type        = string
  description = "ID of the S3 bucket to use as the CloudFront origin"
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "Regional domain name of the S3 bucket"
}

variable "price_class" {
  type        = string
  description = "CloudFront price class — controls which edge locations are used"
  default     = "PriceClass_100"
}
