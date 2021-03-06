#!/bin/bash

set -e

AWS_ACCESS_KEY_ID="$1"
AWS_SECRET_ACCESS_KEY="$2"
SSH_USER_ID="$3"
SSH_PRIVATE_KEY="$4"
REPO_NAME="$5"
BRANCH_NAME="$6"
SVC_USERNAME="$7"
SVC_EMAIL="$8"

mkdir -p /github/home/.ssh && cd /github/home/.ssh && echo "$SSH_PRIVATE_KEY" > id_rsa && chmod 600 id_rsa;

echo "Host git-codecommit.*.amazonaws.com
User $SSH_USER_ID
IdentityFile /github/home/.ssh/id_rsa
StrictHostKeyChecking no" > /etc/ssh/ssh_config.d/codecommit.conf

ssh-keyscan -t rsa -H git-codecommit.us-east-2.amazonaws.com > known_hosts && chmod 600 known_hosts

aws --profile default configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws --profile default configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws --profile default configure set region "us-east-2"

AWS_RESPONSE=$(aws codecommit get-repository --repository-name "$REPO_NAME" || \
    aws codecommit create-repository --repository-name "$REPO_NAME")
CLONE_URL=$(jq -r '.repositoryMetadata.cloneUrlSsh' <<< $AWS_RESPONSE)
CODECOMMIT_URL="ssh://${SSH_USER_ID}@${CLONE_URL:6}" # trim off the first 6 chars "ssh://", add user-id, add ssh:// back

git config --global user.email "$SVC_EMAIL"
git config --global user.name "$SVC_USERNAME"
git config --global --add safe.directory /github/workspace

cd /github/workspace && \
    git remote add codecommit "$CODECOMMIT_URL" && \
    GIT_SSH_COMMAND="ssh -vv" git push codecommit $BRANCH_NAME
