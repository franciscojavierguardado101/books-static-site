# CloudWatch alarms for CloudFront — must be in us-east-1 (CloudFront publishes metrics there only)

# Alarm: client error rate above 5% — usually means broken links or missing assets
resource "aws_cloudwatch_metric_alarm" "error_4xx" {
  alarm_name          = "${var.environment}-books-site-4xx-error-rate"
  alarm_description   = "Books site CloudFront 4xx error rate exceeded 5%"
  namespace           = "AWS/CloudFront"
  metric_name         = "4xxErrorRate"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 5
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = var.distribution_id
    Region         = "Global"
  }

  tags = {
    Environment = var.environment
    Project     = "books-static-site"
  }
}

# Alarm: server/origin error rate above 1% — means S3 origin is unreachable or misconfigured
resource "aws_cloudwatch_metric_alarm" "error_5xx" {
  alarm_name          = "${var.environment}-books-site-5xx-error-rate"
  alarm_description   = "Books site CloudFront 5xx error rate exceeded 1%"
  namespace           = "AWS/CloudFront"
  metric_name         = "5xxErrorRate"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = var.distribution_id
    Region         = "Global"
  }

  tags = {
    Environment = var.environment
    Project     = "books-static-site"
  }
}

# Dashboard: single pane of glass for the Books site health
resource "aws_cloudwatch_dashboard" "books_site" {
  dashboard_name = "${var.environment}-books-static-site"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title  = "CloudFront Requests"
          region = "us-east-1"
          metrics = [
            ["AWS/CloudFront", "Requests", "DistributionId", var.distribution_id, "Region", "Global"]
          ]
          period = 300
          stat   = "Sum"
          view   = "timeSeries"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "Error Rates"
          region = "us-east-1"
          metrics = [
            ["AWS/CloudFront", "4xxErrorRate", "DistributionId", var.distribution_id, "Region", "Global"],
            ["AWS/CloudFront", "5xxErrorRate", "DistributionId", var.distribution_id, "Region", "Global"]
          ]
          period = 300
          stat   = "Average"
          view   = "timeSeries"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "Bytes Downloaded"
          region = "us-east-1"
          metrics = [
            ["AWS/CloudFront", "BytesDownloaded", "DistributionId", var.distribution_id, "Region", "Global"]
          ]
          period = 300
          stat   = "Sum"
          view   = "timeSeries"
        }
      }
    ]
  })
}
