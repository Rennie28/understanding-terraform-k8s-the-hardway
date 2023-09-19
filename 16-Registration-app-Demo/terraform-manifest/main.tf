
terraform {
  required_version = ">=1.1.0"

  backend "s3" {
    bucket         = "prod-nfor"
    key            = "path/evn/16-Registration-app-Demo/terraform-mainfest"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

locals {
  kubernetes             = data.terraform_remote_state.Kubernetes_secrets.outputs
  endpoint               = local.kubernetes.endpoint
  cluster_ca_certificate = base64decode(local.kubernetes.kubeconfig-certificate-authority-data)
  cluster_id             = local.kubernetes.cluster_id
}

data "terraform_remote_state" "Kubernetes_secrets" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "prod-nfor"
    key    = format("env:/%s/path/evn/Create-eks-cluster", terraform.workspace)
  }
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_id
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = local.endpoint
  cluster_ca_certificate = local.cluster_ca_certificate
  token                  = data.aws_eks_cluster_auth.this.token
}
