## GitHub to AWS CodeCommit

This GitHub Action can be added to any existing GitHub repository to have any of
its branches automatically mirrored on CodeCommit.

### Setup
The template file in `.github/workflows/template.yaml` should be copied (and
renamed) to the target repo's `.github/workflows/` folder.

Several inputs are required for this to work. These _must_ be added in the
repository Settings, under Secrets -> Actions, or in the organization's secrets.
1. `CODECOMMIT_AWS_ACCESS_KEY_ID`: the access key for the IAM user with permissions to
CodeCommit. The policy can be found in the `infrastructure/iam.tf` file.
1. `CODECOMMIT_AWS_SECRET_ACCES_KEY`: the secret key that accompanies the above

The policy for this user needs to provide the following access via IAM:
```json
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
```

`gha/codecommit/ssh_private_key` and `gha/codecommit/ssh-key-id` are the secret
names in Secrets Manger. These ARNs need to be changed alongside the secret
names in the template.yaml if they differ from this setup.

The service email and service username are not terribly important. These are
just required to be set by CodeCommit before pushing. Currently, they are set to
SDE service users and can be changed when copying the `template.yaml` to the
target repo.

### Infrastructure
Terraform can manage the aforementioned IAM user. The IaC will take an existing
SSH key stored in Secret Manager (this ARN is currently hardcoded) and attach it
to the IAM user. The policy is also controlled here.
