output "alarm_4xx_arn" {
  value       = aws_cloudwatch_metric_alarm.error_4xx.arn
  description = "ARN of the 4xx error rate alarm"
}

output "alarm_5xx_arn" {
  value       = aws_cloudwatch_metric_alarm.error_5xx.arn
  description = "ARN of the 5xx error rate alarm"
}

output "dashboard_arn" {
  value       = aws_cloudwatch_dashboard.books_site.dashboard_arn
  description = "ARN of the CloudWatch dashboard"
}
