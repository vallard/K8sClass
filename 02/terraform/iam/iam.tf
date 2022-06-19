# Put in your profile name here.  It might be that you want to use the "default" profile.
# see your profiles in ~/.aws/credentials
# if you don't have credentials set in ~/.aws/credentials you can also put in 
# access_key = "...."
# secret_key = "...."
# you can also use environment variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
# more details are found here: 
# https://www.terraform.io/docs/providers/aws/index.html
# select the region you want to perform this operation in. 
provider "aws" {
  profile = "cr"
  region  = "us-west-2"
}

########################################################
# Create the EKS Full Access Policy
########################################################

data "aws_iam_policy_document" "EKSFullAccess" {
  statement {
    sid = "EKSFullAccess"
    actions = [
      "eks:*",
      "ecr:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "EKSFullAccess" {
  name   = "EKSFullAccess"
  path   = "/"
  policy = data.aws_iam_policy_document.EKSFullAccess.json
}


########################################################
# Create the EKS Demo Group
########################################################

resource "aws_iam_group" "EKSDemoGroup" {
  name = "EKSDemoGroup"
  path = "/"
}

########################################################
# Attach AWS managed policies to the group
########################################################

resource "aws_iam_group_policy_attachment" "AmazonEC2FullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonS3FullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonSNSReadOnlyAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonVPCFullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
resource "aws_iam_group_policy_attachment" "IAMReadOnlyAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "AWSCloudFormationFullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_group_policy_attachment" "DynamoFullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_group_policy_attachment" "EKSFullAccess" {
  group      = aws_iam_group.EKSDemoGroup.name
  policy_arn = aws_iam_policy.EKSFullAccess.arn
}



########################################################
# Attach AWS inline policy to the group
########################################################

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iamPassRole" {
  statement {
    actions = [
      "ssm:GetParameter",
      "iam:PassRole",
      "iam:GetRole",
      "iam:CreateServiceLinkedRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.us-west-2.amazonaws.com",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.us-west-2.amazonaws.com/*",
      "arn:aws:ssm:*"
    ]
  }
}

resource "aws_iam_policy" "iamPassRole" {
  name   = "iamPassRole"
  path   = "/"
  policy = data.aws_iam_policy_document.iamPassRole.json
}

resource "aws_iam_group_policy" "iamPassRole" {
  group  = aws_iam_group.EKSDemoGroup.name
  name   = "iamPassRole"
  policy = data.aws_iam_policy_document.iamPassRole.json
}


########################################################
# Create EKS Demo user and add to group
########################################################

resource "aws_iam_user" "eksdude" {
  name          = "eksdude"
  force_destroy = "true"
}

resource "aws_iam_user_group_membership" "eksdude" {
  user = aws_iam_user.eksdude.name
  groups = [
    aws_iam_group.EKSDemoGroup.name
  ]
}

data "aws_iam_policy_document" "eksdude" {
  statement {
    actions = [
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.eksdude.name}"
    ]
  }
}

resource "aws_iam_user_policy" "eksdude" {
  name   = "ConsolePolicy"
  user   = aws_iam_user.eksdude.name
  policy = data.aws_iam_policy_document.eksdude.json

}

resource "aws_iam_user_login_profile" "eksdude" {
  user            = aws_iam_user.eksdude.name
  pgp_key         = var.pgp_key
  password_length = 10

  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
}

output "password" {
  value = aws_iam_user_login_profile.eksdude.encrypted_password
}

resource "aws_iam_access_key" "eksdude" {
  user    = aws_iam_user.eksdude.name
  pgp_key = var.pgp_key
}

output "secret" {
  value = aws_iam_access_key.eksdude.encrypted_secret
}

output "key" {
  value = aws_iam_access_key.eksdude.id
}

########################################################
# Create EKS Service Role for Manual Kubernetes Clusters
########################################################

resource "aws_iam_role" "EKSServiceRole" {
  name               = "EKSServiceRole"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "eks.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsCluster" {
  role       = aws_iam_role.EKSServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsService" {
  role       = aws_iam_role.EKSServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


########################################################
# Create Cluster Autoscaling Policy
########################################################

data "aws_iam_policy_document" "EKSClusterAutoscaling" {
  statement {
    sid = "EKSClusterAutoscaling"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "EKSClusterAutoscaling" {
  name   = "EKSClusterAutoscaling"
  path   = "/"
  policy = data.aws_iam_policy_document.EKSClusterAutoscaling.json
}

########################################################
# EKS role for creating EKS clusters
########################################################


data "aws_iam_policy_document" "eks_dude_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_user.eksdude.arn
      ]
    }
  }
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
}

resource "aws_iam_role" "eks_dude_role" {
  name               = "eks_dude_role"
  assume_role_policy = data.aws_iam_policy_document.eks_dude_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    aws_iam_policy.iamPassRole.arn,
    aws_iam_policy.EKSFullAccess.arn
  ]
}

/*
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
*/


########################################################
# EKS node group role
########################################################

data "aws_iam_policy_document" "eks_node_group_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.eks_dude_role.arn
      ]
    }
  }
}

resource "aws_iam_role" "eks_node_group" {
  name               = "eks_node_group"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
