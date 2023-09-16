terraform {
  backend "s3" {
    bucket         = "rhresume-terraform-bucket-remote-state"
    key            = "cloud-resume-terraform/iam_resources/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rhresume_app_state"
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}
