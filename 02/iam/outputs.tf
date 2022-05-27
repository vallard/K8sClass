output "iam" {
  value = {
    "eks_dude_role" : {
      "name" : aws_iam_role.eks_dude_role.name,
      "arn" : aws_iam_role.eks_dude_role.arn
    }
    "eks_service_role" : {
      "name" : aws_iam_role.EKSServiceRole.name,
      "arn" : aws_iam_role.EKSServiceRole.arn
    }
    "eks_node_group_role" : {
      "name" : aws_iam_role.eks_node_group.name,
      "arn" : aws_iam_role.eks_node_group.arn
    }
  }
}
