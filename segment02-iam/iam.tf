
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


# The below variable is my pgp public key base64 encoded.  This is used to create the password
# and secret_key of the iam user below.  You can change this to be your own key. 
variable "pgp_key" {
  type = string
  default = "mQENBF5+OpwBCACzSl0NO2M7tSi4vgh1jUlz484bLjrYN2J9nQU88Okbd+WqCMI1UxaHOqJ4gkX1Za6TA1dTxpoAR1694y5v2HllZVwz7rPkt+fptQgj3QBmUX8Pm13FYqF9kLZ2SZPGLgAnkpoSYel8u8xYmlgtjzG3CamLwDPFnJAh/tPG25VKqJU5Uumd7sAZgDdiF1LF6/LQdEtEJhJdQh6mGGZcLB60HPWIO92vbSJB9CvnwsN+chXrE7IFG2AX7XsMYGdZxxIZBLvjUvMzmFORzlRVieR5KuC7rgONeNZULwRq4hh0BWl/mx3BwKf3HAw1GeDr0jcPM2i/QUPKR561T3ZfPpPrABEBAAG0NVZhbGxhcmQgQmVuaW5jb3NhIChla3MtY2xhc3MpIDx2YWxsYXJkQGJlbmluY29zYS5jb20+iQFOBBMBCAA4FiEE/SwuwMUBBSnbF8gMskZ+QvV4g6MFAl5+OpwCGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQskZ+QvV4g6MhxwgAszsCcU2Na+SDLkPXUP+76LTDpQT7fdsPX4dh5qyiNEkL0jmoEplG4xzqaVLwn3OvB7OTn0OqdYfe7fZTP/LOecUOSLKN8whXXNr6GUw5D4ZE79utBrwh1swC2Lzj0pKrMduTSW//U2TL5XQE/ncOiLL74HllLH9OVmKqQDH3LoM9EZbCBxNf0oT/oAMcDrl9wOX9/6gW4tmM1p8OmFBPRprc06XYTCWi0SME0kB95uet+PB2lDmWwwqVyUh2lMMtIvxCtK/wv8bcouy18PYqH9b88nLf/rt9VHEeBuFS82xxTUVVG+PEq2qmCFkhYPX+JQDeEV5byAJqXxXIUI6uXLkBDQRefjqcAQgApA5bBbvQ6JxAYF05L2phFcmfKY25jF+s4eTBQiG5jPYLi2MSpyrgRrLcss12JkESU/zuY0N58j1P5KHL+BbvFD5c9oIzoPx5DaSbK/m8W3MwwJ7Qj8Di/uYz5UasUxGv4Moc8u0KXcMwSGMcA9PczlJ1uoZ2jpQlzA03pYeb5rw32nLA+8iNqqsyOXVSw730fEYs+rjyKqSUyFw11uywb2QemjwsxFlRU48zPG5nyaNCSTvXLHTtzCqD/1jm+/kpr5gv13oxIioiSmmPlGpbtFWjWA3oEaPTvXVZ5FAS9BNiHCLS9TBM1Qd2AX4IqeXYg4RPJJIOaltY1lHsX+5QqQARAQABiQE2BBgBCAAgFiEE/SwuwMUBBSnbF8gMskZ+QvV4g6MFAl5+OpwCGwwACgkQskZ+QvV4g6OSmAf9H7yOy61uKmdyjeKL/FMHl+cRrdhlmgnXgCwJGKLWQlTOHDX5VFiYVz9ImYSK8PhiUQDp3L2RQCXbwuK0xvxgG6lQ4vj/q5nsp5aW1Osb2SNSGx6y71Kt6F92J0I3cpGEzd3ZaV/+lbaPUAZFbXaaegjUe0kJcyyvfrhFeuQVWNuA8P5hQImi0BDWgCoyNmYJYOIv+e/znBYHPmALKrdCrODNUVl33hQtRSBPhqNgILK2a+ZvgAmBA4s7m2M2eyFXBOjYSQz2gE87PydBN6P1MNO42BuBMZtHEeSDDmrLPBYosfwXMDL3UJRZMimV2s4sZAoO6ai8ykeyIcJToR9pBw=="
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

resource "aws_iam_group_policy_attachment" "DynamoFullAccess" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
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
      "iam:CreateInstanceProfile",
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
  name = "ConsolePolicy"
  user = aws_iam_user.eksdude.name
  policy = data.aws_iam_policy_document.eksdude.json
  
}

resource "aws_iam_user_login_profile" "eksdude" {
  user = aws_iam_user.eksdude.name
  pgp_key = var.pgp_key
  password_length = 10

  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
}

output "password" {
  value = aws_iam_user_login_profile.eksdude.encrypted_password
}

resource "aws_iam_access_key" "eksdude" {
  user = aws_iam_user.eksdude.name
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
  name = "EKSClusterAutoscaling"
  path = "/"
  policy = data.aws_iam_policy_document.EKSClusterAutoscaling.json
}



########################################################
# Create Serverless Policy and attach to the EKSDemoGroup
########################################################

data "aws_iam_policy_document" "Serverless" {
  statement {
    sid = "Serverless"
    actions = [
      "apigateway:*",
      "logs:*",
      "lambda:*"
    ]
    resources = [
      "*"
    ]
  }
}
resource "aws_iam_policy" "Serverless" {
  name = "Serverless"
  path = "/"
  policy = data.aws_iam_policy_document.Serverless.json
}

resource "aws_iam_group_policy_attachment" "EKSDemoGroupServerless" {
  group = aws_iam_group.EKSDemoGroup.name
  policy_arn  = aws_iam_policy.Serverless.arn
}


########################################################
# Create KubeLambda Role and attach Policies
########################################################

resource "aws_iam_role" "kubeLambda" {
  name = "kubeLambda"
  description = "Allows Lambda functions to make kubernetes calls on our cluster."
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}


resource "aws_iam_role_policy_attachment" "kubeLambdaEKSFullAccess" {
  role = aws_iam_role.kubeLambda.name
  policy_arn  = aws_iam_policy.EKSFullAccess.arn
}

resource "aws_iam_role_policy_attachment" "kubeLambdaServerless" {
  role = aws_iam_role.kubeLambda.name
  policy_arn  = aws_iam_policy.Serverless.arn
}

resource "aws_iam_role_policy_attachment" "kubeLambdaLambda" {
  role = aws_iam_role.kubeLambda.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

########################################################
# Add Dynamo Role 
########################################################


