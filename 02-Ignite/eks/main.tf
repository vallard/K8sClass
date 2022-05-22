

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
  alias   = "aws_assume_role"
  region  = "us-west-2"
  profile = "eksdude"
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
