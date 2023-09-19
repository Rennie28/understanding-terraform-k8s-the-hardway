

terraform {
  required_version = ">=1.1.0"

  backend "s3" {
    bucket         = "terraform-remote-state-datasource"
    key            = "path/evn"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
  }
}
