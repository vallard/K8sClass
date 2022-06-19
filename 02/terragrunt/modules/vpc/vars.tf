variable "env" {
  type        = string
  description = "run time environment. e.g: stage, prod, dev"
}

variable "region" {
  type = string
  description = "region. e.g: us-west-2"
}

variable "cidr" {
  type = string
  description = "cidr for network, e.g: 10.0.0.0/16"
}

variable "private_subnets" {
  type = list(string)
  description = "list of private subnets: [10.0.1.0/24, 10.0.2.0/24,...]"
}

variable "public_subnets" {
  type = list(string)
  description = "list of public subnets: [10.0.201.0/24, 10.0.202.0/24,...]"
}
