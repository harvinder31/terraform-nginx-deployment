output "cloudfront_domain_name" {
  value = aws_cloudfront_health_distribution.s3_distribution.domain_name
}
