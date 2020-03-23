
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
