terraform {
  required_version = ">=1.1.0"

  # backend "s3" {
  #     bucket = "zayne.state.bucket"
  #     key = "path/evn"
  #     region = "us-east-1"
  #     aws_dynamodb_table = "terraform-lock"
  #     encrypt = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
}