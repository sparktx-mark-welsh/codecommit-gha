resource "aws_iam_user" "codecommit_gha_service_user" {
  name = "codecommit_gha_service_user"
  path = "/service-users/"
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.codecommit_gha_service_user.name
}

resource "aws_iam_user_policy" "codecommit_policy" {
  name = "codecommit_gha_service_user_policy"
  user = aws_iam_user.codecommit_gha_service_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codecommit:GetRepository",
        "codecommit:CreateBranch",
        "codecommit:CreateRepository",
        "codecommit:CreateCommit",
        "codecommit:GitPush",
        "codecommit:GitPull"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "codecommit:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:secretsmanager:us-east-2:125195589298:secret:gha/codecommit/ssh_private_key-oRAcKG",
        "arn:aws:secretsmanager:us-east-2:125195589298:secret:gha/codecommit/ssh-key-id-JRFiMJ"
      ]
    }
  ]
}
EOF
}

data "aws_secretsmanager_secret" "ssh_key_secret" {
  arn = "arn:aws:secretsmanager:us-east-2:125195589298:secret:gha/codecommit/ssh_public_key-QRXWzH"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.ssh_key_secret.id
}

resource "aws_iam_user_ssh_key" "gha_codecommit_ssh_key" {
  username   = aws_iam_user.codecommit_gha_service_user.name
  encoding   = "SSH"
  public_key = data.aws_secretsmanager_secret_version.current.secret_string
}
