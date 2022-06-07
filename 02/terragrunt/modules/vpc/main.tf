locals {
  iam_state = data.terraform_remote_state.iam.outputs.iam
}

module "vpc_example_simple-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.14.0"
  name            = "eks-vpc-${var.env}"
  cidr            = var.cidr
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "eksdude"
    Environment = "K8sClass-${var.env}"
  }

  vpc_tags = {
    Name        = "K8sClass-${var.env}"
    Environment = var.env
  }
}

