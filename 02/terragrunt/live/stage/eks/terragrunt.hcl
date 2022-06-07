include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/eks"
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = ["${get_parent_terragrunt_dir()}/common.tfvars"]
  }
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  public_subnets = dependency.vpc.outputs.vpc.public_subnets
  k8s_version = 1.21
}
