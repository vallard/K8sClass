variable "env" {
  type        = string
  description = "run time environment. e.g: stage, prod, dev"
}

variable "public_subnets" {
  type        = list(string)
  description = "default subnets"
}

variable "region" {
  type        = string
  description = "region: e.g: us-west-2"
}

variable "k8s_version" {
  type = string
  description = "kubernetes version: e.g: 1.22"
}

