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
  description = "region to deploy, eg: us-west-2"
}
