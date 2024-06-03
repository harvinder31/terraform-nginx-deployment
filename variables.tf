variable "aws_region" {
  description = "AWS Region for the resources"
  type        = string
  default     = "us-west-2"
}

variable "access_key" {
  description = "AWS Access Key ID"
  type        = string
}

variable "secret_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 Bucket name for storing files"
  type        = string
}
