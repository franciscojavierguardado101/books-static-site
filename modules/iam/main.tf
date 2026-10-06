# IAM user for deploying Books site files to S3 — least privilege, only what the deploy workflow needs
resource "aws_iam_user" "deployer" {
  name = "${var.environment}-books-site-deployer"

  tags = {
    Environment = var.environment
    Project     = "books-static-site"
    Purpose     = "ci-cd-deployment"
  }
}

# Policy scoped to the Books site bucket only
resource "aws_iam_policy" "deployer" {
  name        = "${var.environment}-books-site-deployer-policy"
  description = "Least privilege policy for deploying Books static site files to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "deployer" {
  user       = aws_iam_user.deployer.name
  policy_arn = aws_iam_policy.deployer.arn
}
