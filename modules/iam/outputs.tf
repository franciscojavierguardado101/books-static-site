output "deployer_user_name" {
  value = aws_iam_user.deployer.name
}

output "deployer_user_arn" {
  value = aws_iam_user.deployer.arn
}

output "deployer_policy_arn" {
  value = aws_iam_policy.deployer.arn
}
