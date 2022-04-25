terraform {
  backend "s3" {
    bucket = "sparktx-serviceusers-tf"
    key    = "codecommit-gha-service-user.tfstate"
    region = "us-east-2"
  }
}
