output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.secure_cloud_storage.repository_url
}


output "github_actions_role_arn" {
  description = "IAM Role ARN for GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}

