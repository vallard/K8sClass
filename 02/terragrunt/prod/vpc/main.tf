locals {
  iam_state = data.terraform_remote_state.iam.outputs.iam
}

module "vpc_example_simple-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.14.0"
  name            = "eks-vpc-${var.env}"
  cidr            = "10.0.0.0/16"
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

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

