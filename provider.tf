provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "us-west-2"
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
