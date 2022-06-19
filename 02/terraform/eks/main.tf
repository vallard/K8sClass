

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    region = "us-west-2"
    bucket = "k8sclass-tf-state"
    key    = "iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region = "us-west-2"
    bucket = "k8sclass-tf-state"
    key    = "network/terraform.tfstate"
  }
}

locals {
  iam_state = data.terraform_remote_state.iam.outputs.iam
  net_state = data.terraform_remote_state.vpc.outputs.vpc
}

provider "aws" {
  region  = "us-west-2"
  assume_role {
    role_arn = local.iam_state.eks_dude_role.arn
  }
}

resource "aws_eks_cluster" "cluster" {
  name = "eks-demo-cluster"
  vpc_config {
    subnet_ids = local.net_state.public_subnets
  }
  role_arn = local.iam_state.eks_service_role.arn
  version  = "1.22"
}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-demo-nodegroup"
  node_role_arn   = local.iam_state.eks_node_group_role.arn
  subnet_ids      = local.net_state.public_subnets
  scaling_config {
    desired_size = 2
    max_size     = 6
    min_size     = 1
  }
  instance_types = ["t3.small"]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
