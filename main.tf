resource "aws_s3_bucket" "upload_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"  // example AMI ID, please replace with your specific AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              # Install Docker
              apt update
              apt install -y docker.io
              # Start Docker and run Nginx container
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:80 \
                -e AWS_ACCESS_KEY_ID=${var.access_key} \
                -e AWS_SECRET_ACCESS_KEY=${var.secret_key} \
                -e S3_BUCKET_NAME=${var.s3_bucket_name} \
                -e AWS_REGION=${var.aws_waregion} \
                nginx
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = aws_launch_configuration.app.id
  min_size             = 1
  max_size             = 10
}

resource "aws_launch_configuration" "app" {
  name          = "app-launch-configuration"
  image_id      = aws_instance.app_server.ami
  instance_type = aws_instance.app_server.instance_type
  user_data     = aws_instance.app_server.user_data
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.upload_bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.upload_bucket.id}"
  }

  enabled             = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.upload_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "www.example.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s4_distribution.domain_name
    zone_id                = aws_cloudfrint_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
