# S3 bucket for Books static site files
module "s3_website" {
  source      = "../../modules/s3-website"
  bucket_name = "francisco-guardado-books-${var.environment}-site"
  environment = var.environment
}

# CloudFront CDN — serves the Books site globally with HTTPS
module "cloudfront" {
  source                         = "../../modules/cloudfront"
  environment                    = var.environment
  s3_bucket_id                   = module.s3_website.bucket_id
  s3_bucket_regional_domain_name = module.s3_website.bucket_regional_domain_name
  price_class                    = "PriceClass_100"
}

# Bucket policy — allows CloudFront OAC to read from the private S3 bucket
resource "aws_s3_bucket_policy" "books_site" {
  bucket = module.s3_website.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3_website.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.distribution_arn
          }
        }
      }
    ]
  })
}

# IAM deployer user — least privilege S3 access for the deploy workflow
module "iam" {
  source        = "../../modules/iam"
  environment   = var.environment
  s3_bucket_arn = module.s3_website.bucket_arn
}

# CloudWatch alarms — monitors CloudFront error rates and request volume
module "cloudwatch" {
  source              = "../../modules/cloudwatch"
  environment         = var.environment
  distribution_id     = module.cloudfront.distribution_id
  providers = {
    aws = aws.us_east_1
  }
}

# GCS bucket — backup mirror of the Books site on Google Cloud
module "gcs_backup" {
  source        = "../../modules/gcs-backup"
  bucket_name   = "francisco-guardado-books-${var.environment}-site-backup"
  location      = "US"
  environment   = var.environment
  force_destroy = true
}
