output "opensearch" {
  value = {
    "domain_name" : aws_opensearch_domain.cluster.domain_name
    "domain_arn" : aws_opensearch_domain.cluster.arn
    "domain_endpoint" : aws_opensearch_domain.cluster.endpoint
  }
}
