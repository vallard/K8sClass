locals {
  iam_state = data.terraform_remote_state.iam.outputs.iam
}

resource "aws_eks_cluster" "cluster" {
  name = "eks-${var.env}"
  vpc_config {
    subnet_ids = var.public_subnets
  }
  role_arn = local.iam_state.eks_service_role.arn
  version  = var.k8s_version
  tags = {
    Environment = "K8sClass-${var.env}"
  }
}

resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-nodegroup-${var.env}"
  node_role_arn   = local.iam_state.eks_node_group_role.arn
  subnet_ids      = var.public_subnets
  scaling_config {
    desired_size = 2
    max_size     = 6
    min_size     = 1
  }
  instance_types = ["t3.small"]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
