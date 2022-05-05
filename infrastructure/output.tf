output "iam-access-key-id" {
  value = aws_iam_access_key.key.id
}

output "iam-access-key-secret" {
  value     = aws_iam_access_key.key.secret
  sensitive = true
}

output "iam-ssh-key-id" {
  value = aws_iam_user_ssh_key.gha_codecommit_ssh_key.ssh_public_key_id
}
