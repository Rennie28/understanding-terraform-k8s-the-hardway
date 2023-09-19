terraform {
  required_version = ">=1.1.0"

  backend "s3" {
    bucket         = "boseme-bucket"
    key            = "path/evn/create-eks-cluster"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
}


module "networking" {
  source = "../08-rennies-modules/networking-modules"

  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidr   = ["10.0.0.0/24", "10.0.2.0/24"]
  private_subnet_cidr  = ["10.0.1.0/24", "10.0.3.0/24"]
  database_subnet_cidr = ["10.0.31.0/24", "10.0.33.0/24"]

  ### TAGS
  public_subnet_tags = {
    Type                                                                = "public-subnets"
    "kubernetes.io/role/elb"                                            = 1
    "kubernetes.io/cluster/${format("%s-cluster", var.component_name)}" = "shared"
  }
  private_subnet_tags = {
    Type                                                                = "private-subnets"
    "kubernetes.io/role/elb"                                            = 1
    "kubernetes.io/cluster/${format("%s-cluster", var.component_name)}" = "shared"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

}

resource "aws_security_group_rule" "allow_applications_port_for_demo" {
  type              = "ingress"
  description       = "allow_applications_port_for_demo"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
#//referencing parent module

########################################################################
# EKS CLUSTER
########################################################################

resource "aws_eks_cluster" "this" {
  name     = format("%s-cluster", var.component_name)
  role_arn = aws_iam_role.eks_master_node.arn

  vpc_config {
    subnet_ids = module.networking.public_subnet_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

########################################################################
# WORKER NODE GROUP
########################################################################
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = format("%s-node-group", var.component_name)
  node_role_arn   = aws_iam_role.eks_nodegroup.arn
  subnet_ids      = module.networking.public_subnet_id

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = format("%s-node-group", var.component_name)
  }
}

