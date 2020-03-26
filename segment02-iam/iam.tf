
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
  region = "us-west-1"
}


########################################################
# Create the EKS Full Access Policy
########################################################

data "aws_iam_policy_document" "EKSFullAccess" {
  statement {
    sid = "EKSFullAccess"
    actions = [
      "eks:*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "EKSFullAccess" {
  name = "EKSFullAccess"
  path = "/"
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
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonS3FullAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonSNSReadOnlyAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "AmazonVPCFullAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}
resource "aws_iam_group_policy_attachment" "IAMReadOnlyAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "AWSCloudFormationFullAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_group_policy_attachment" "EKSFullAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = aws_iam_policy.EKSFullAccess.arn
}

########################################################
# Attach AWS inline policy to the group
########################################################

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iamPassRole" {
  statement {
    actions = [
      "iam:PassRole",
      "iam:CreateServiceLinkedRole",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:CreateInstanceProfile"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
    ]
  } 
}

resource "aws_iam_group_policy" "iamPassRole" {
  group = aws_iam_group.EKSDemoGroup.name
  name = "iamPassRole"
  policy = data.aws_iam_policy_document.iamPassRole.json
}


########################################################
# Create EKS Demo user and add to group
########################################################

resource "aws_iam_user" "eksdude" {
  name = "eksdude"
}

resource "aws_iam_user_group_membership" "eksdude_groups" {
  user = aws_iam_user.eksdude.name
  groups = [
    aws_iam_group.EKSDemoGroup.name
  ]
}

########################################################
# Create EKS Service Role for Manual Kubernetes Clusters
########################################################

resource "aws_iam_role" "EKSServiceRole" {
  name = "EKSServiceRole"
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
  role = aws_iam_role.EKSServiceRole.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "EKSServiceRoleAttachmentsService" {
  role = aws_iam_role.EKSServiceRole.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}
