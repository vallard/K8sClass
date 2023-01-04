output "eks" {
  value = {
    "cluster_security_group_id" : aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
  }
}
