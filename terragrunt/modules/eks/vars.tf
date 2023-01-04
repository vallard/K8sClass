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
  type        = string
  description = "kubernetes version: e.g: 1.22"
}

variable "min_nodes" {
  type        = number
  description = "min nodes:  Less than desired nodes and max nodes"
  default     = 1
}

variable "desired_nodes" {
  type        = number
  description = "how many kubernetes worker nodes should we have."
  default     = 2
}

variable "max_nodes" {
  type        = number
  description = "max nodes: how many nodes max?"
  default     = 3
}
