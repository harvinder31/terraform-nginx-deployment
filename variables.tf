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

variable "domain_name" {
  description = "The domain name to use for the Route 53 hosted zone."
}
