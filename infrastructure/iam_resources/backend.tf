terraform {
  backend "s3" {
    bucket         = "rhresume-terraform-bucket-remote-state"
    key            = "cloud-resume-terraform/iam_resources/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rhresume_app_state"
    encrypt        = true
  }
}
