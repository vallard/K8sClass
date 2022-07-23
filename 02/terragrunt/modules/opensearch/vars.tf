variable "env" {
  type        = string
  description = "run time environment. e.g: stage, prod, dev"
}

variable "es_version" {
  type        = string
  description = "Opensearch version: e.g: Opensearch_1.2"
}

variable "instance_type" {
  type        = string
  description = "Opensearch instance type: e.g: t2.small.search"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets to use for the Opensearch cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to use for the Opensearch cluster"
}

variable "vpc_cidr_blocks" {
  type        = list(string)
  description = "VPC CIDR blocks to use for the Opensearch cluster"
}

variable "eks_security_group_id" {
  type        = string
  description = "EKS security group to use for the Opensearch cluster, we use this to allow EKS to access opensearch"
}
