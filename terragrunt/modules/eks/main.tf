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
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }
  instance_types = ["t3.small"]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  tags = {
    "k8s.io/cluster-autoscaler/eks_${var.env}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"        = "true"
  }
}


# service accounts for EBS CSI Driver and Cluster Autoscaler

resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  url             = local.eks_oidc_issuer_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
  tags = {
    Name = "eks_${var.env}"
  }
}


locals {
  eks_oidc_issuer_url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  eks_oidc_issuer_id  = replace(local.eks_oidc_issuer_url, "https://", "")
  eks_oidc_arn        = aws_iam_openid_connect_provider.eks_oidc_provider.arn
}

data "aws_iam_policy_document" "ebs_controller_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [local.eks_oidc_arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# make ebs controller role
resource "aws_iam_role" "ebs_controller_role" {
  name               = "EKS_EBS_CSI_DriverRole_${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ebs_controller_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsCluster" {
  role       = aws_iam_role.ebs_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


resource "aws_eks_addon" "ebs_controller" {
  cluster_name             = aws_eks_cluster.cluster.name
  addon_name               = "aws-ebs-csi-driver"
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = aws_iam_role.ebs_controller_role.arn
}


# update the Autoscaling Role to have the trust relationship

data "aws_iam_policy_document" "autoscaling_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [local.eks_oidc_arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "autoscaling" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/eks_${var.env}"
      values   = ["owned"]
    }
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:SetDesiredCapacity",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autoscaling" {
  name        = "EKSAutoscaling_${var.env}"
  description = "Policy for EKS Autoscaling"
  policy      = data.aws_iam_policy_document.autoscaling.json
}

resource "aws_iam_role" "eks_autoscaling" {
  name               = "EKSAutoscaling_${var.env}"
  assume_role_policy = data.aws_iam_policy_document.autoscaling_assume_role_policy.json
}


resource "aws_iam_role_policy_attachment" "eks_autoscaling" {
  role       = aws_iam_role.eks_autoscaling.name
  policy_arn = aws_iam_policy.autoscaling.arn
}

# Create the DynamoDB service Account

data "aws_iam_policy_document" "dynamo_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [local.eks_oidc_arn]
      type        = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:sub"
      values   = ["system:serviceaccount:default:dynamo"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.eks_oidc_issuer_id}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# Create the policy to allow DynamoDB access
data "aws_iam_policy_document" "dynamo" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:Scan",
    ]
    resources = ["arn:aws:dynamodb:us-west-2:188966951897:table/dynamoUsers"]
  }
}

# Create the policy to allow DynamoDB access 
resource "aws_iam_policy" "dynamo" {
  name        = "EKSDynamoSA_${var.env}"
  description = "Policy for Dynamo Access for service accounts"
  policy      = data.aws_iam_policy_document.dynamo.json
}

# Create the role to allow DynamoDB access
resource "aws_iam_role" "dynamo" {
  name               = "EKSDynamoSA_${var.env}"
  assume_role_policy = data.aws_iam_policy_document.dynamo_assume_role_policy.json
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "dynamo" {
  role       = aws_iam_role.dynamo.name
  policy_arn = aws_iam_policy.dynamo.arn
}
