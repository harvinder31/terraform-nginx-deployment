resource "aws_s3_bucket" "web_app_bucket" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    expiration {
      days = 30
    }
  }
}

resource "aws_instance" "web_app" {
  ami             = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type   = "t2.micro"
  key_name        = "your-key-name" # Replace with your key name
  security_groups = [aws_security_group.web_app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              docker run -d -p 80:80 -e AWS_ACCESS_KEY_ID=${var.aws_access_key_id} -e AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key} -e S3_BUCKET_NAME=${var.s3_bucket_name} -e AWS_REGION=${var.aws_region} techamror007/node-hello
              EOF

  tags = {
    Name = "web_app"
  }
}

resource "aws_security_group" "web_app_sg" {
  name        = "web_app_sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudfront_distribution" "web_app_distribution" {
  origin {
    domain_name = aws_instance.web_app.public_dns
    origin_id   = "webAppOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for Web App"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "webAppOrigin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_launch_configuration" "web_app_lc" {
  name          = "web-app-lc"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "your-key-name"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              docker run -d -p 80:80 -e AWS_ACCESS_KEY_ID=${var.aws_access_key_id} -e AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key} -e S3_BUCKET_NAME=${var.s3_bucket_name} -e AWS_REGION=${var.aws_region} techamror007/node-hello
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  launch_configuration = aws_launch_configuration.web_app_lc.id
  vpc_zone_identifier  = ["subnet-xxxxxxxx"] # Replace with your subnet

  tag {
    key                 = "Name"
    value               = "web_app_asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_route53_zone" "web_app_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "web_app_record" {
  zone_id = aws_route53_zone.web_app_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.web_app_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_app_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

variable "domain_name" {
  description = "The domain name to use for the Route 53 hosted zone."
}

variable "aws_access_key_id" {
  description = "The AWS Access Key ID"
}

variable "aws_secret_access_key" {
  description = "The AWS Secret Access Key"
}

variable "s3_bucket_name" {
  description = "The S3 bucket name for file storage"
}

variable "aws_region" {
  description = "The AWS region"
  default     = "us-west-2"
}

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
