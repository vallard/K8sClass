remote_state {
  backend = "s3"
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "k8sclass-tf-state"
    key = "prod/${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = "us-west-2"
  /*assume_role {
    role_arn = local.iam_state.eks_dude_role.arn
  }*/
}
EOF
}

generate "locals" {
  path = "state.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    region = "us-west-2"
    bucket = "k8sclass-tf-state"
    key    = "iam/terraform.tfstate"
  }
}
EOF
}
