output "s3_bucket_name" {
  value = aws_s3_bucket.web_app_bucket.bucket
}

output "ec2_instance_public_ip" {
  value = aws_instance.web_app.public_ip
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.web_app_distribution.domain_name
}

output "route53_domain_name" {
  value = var.domain_name
}
