include "root" {
  path = find_in_parent_folders()
}

terraform {
  extra_arguments "common_vars" {
    commands = get_terraform_commands_that_need_vars()
    arguments = [
      "-var-file=../common.tfvars"
    ]
  }
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  public_subnets = dependency.vpc.outputs.vpc.public_subnets
}
