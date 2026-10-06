output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The URL to access the Books site via CloudFront"
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}
