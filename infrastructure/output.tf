output "iam-user-id" {
  value = aws_iam_user.codecommit_gha_service_user.unique_id
}

output "iam-access-key-id" {
  value = aws_iam_access_key.key.id
}

output "iam-access-key-secret" {
  value     = aws_iam_access_key.key.secret
  sensitive = true
}
