include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//opensearch"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = ["${get_parent_terragrunt_dir()}/common.tfvars"]
  }
}

dependency "vpc" {
  config_path = "..//vpc"
}

dependency "eks" {
  config_path = "..//eks"
}

inputs = {
  subnets = dependency.vpc.outputs.vpc.private_subnets
  es_version = "OpenSearch_1.2"
  instance_type = "t2.small.search"
  vpc_id = dependency.vpc.outputs.vpc.vpc_id
  vpc_cidr_blocks = dependency.vpc.outputs.vpc.private_subnets_cidr_blocks
  eks_security_group_id = dependency.eks.outputs.eks.cluster_security_group_id
}
