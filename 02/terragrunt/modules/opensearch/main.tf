data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_service_linked_role" "cluster" {
  aws_service_name = "opensearchservice.amazonaws.com"
}

resource "aws_security_group" "cluster" {
  name        = "opensearch-${var.env}"
  description = "Opensearch security groups for ${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }
}

resource "aws_opensearch_domain" "cluster" {
  domain_name    = "opensearch-${var.env}"
  engine_version = var.es_version

  cluster_config {
    instance_type = var.instance_type
  }

  ebs_options {
    ebs_enabled = "true"
    volume_size = "10"
  }

  vpc_options {
    subnet_ids         = [var.subnets[0]]
    security_group_ids = [aws_security_group.cluster.id]
  }

  access_policies = <<CONFIG
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "es:*",
                "Principal": "*",
                "Effect": "Allow",
                "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/opensearch-${var.env}/*"
            }
        ]
    }
    CONFIG

  tags = {
    Env = var.env
  }

  depends_on = [aws_iam_service_linked_role.cluster]
}
