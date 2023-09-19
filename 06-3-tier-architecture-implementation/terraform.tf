terraform {
  required_version = "1.5.7"

  backend "s3" {
    bucket         = "06-3-tier-architecture-implementation"
    key            = "path/evn"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
