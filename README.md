## GitHub to AWS CodeCommit

This GitHub Action can be added to any existing GitHub repository to have any of
its branches automatically mirrored on CodeCommit.

### Setup
The template file in `.github/workflows/template.yaml` should be copied (and
renamed) to the target repo's `.github/workflows/` folder.

Several inputs are required for this to work. These _must_ be added in the
repository Settings, under Secrets -> Actions:
1. `AWS_ACCESS_KEY_ID`: the access key for the IAM user with permissions to
CodeCommit. The policy can be found in the `infrastructure/iam.tf` file.
1. `AWS_SECRET_ACCES_KEY`: the secret key that accompanies the above
1. `SSH_USER_ID`: this is _NOT_ the IAM unique ID. `SSH_USER_ID` can only be
found after an SSH key was added to the IAM user in the IAM console under
"Security credentials -> SSH keys for AWS CodeCommit -> SSH key ID"
1. `SSH_PRIVATE_KEY`: the RSA private key that was added to the AWS IAM user

The service email and service username are not terribly important. These are
just required to be set by CodeCommit before pushing. Currently, they are set to
SDE service users and can be changed when copying the `template.yaml` to the
target repo.

### Infrastructure
Terraform can manage the aforementioned IAM user. The IaC will take an existing
SSH key stored in Secret Manager (this ARN is currently hardcoded) and attach it
to the IAM user. The policy is also controlled here.
