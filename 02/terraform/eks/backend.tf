terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "k8sclass-tf-state"
    key    = "eks/terraform.tfstate"
  }
}
