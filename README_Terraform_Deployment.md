# Terraform Deployment for Dockerized Web Application on AWS

This repository contains Terraform scripts to deploy a Dockerized web application on AWS with the following features:
- Utilizes an S3 bucket for file storage
- Fronted by a CloudFront CDN for improved performance
- Managed domain name using Amazon Route 53
- Implements auto-scaling for handling varying workloads

## Structure

- `provider.tf`: Configures the AWS provider with the necessary credentials and region.
- `main.tf`: Contains all the Terraform configuration to deploy the web application, including S3, EC2, CloudFront, Auto 
  Scaling, and Route 53.
- `variables.tf`: Defines the variables used in the configuration.
- `outputs.tf`: Outputs important information after deployment.

## Environment Variables

The following environment variables need to be set in your Terraform scripts:
- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.
- `S3_BUCKET_NAME`: The name of the S3 bucket.
- `AWS_REGION`: The AWS region to deploy resources (default is `us-west-2`).
- `DOMAIN_NAME`: The domain name for the Route 53 hosted zone.

## Usage

1. **Clone the repository:**

   ```sh
   git clone https://github.com/harvinder31/terraform-nginx-deployment.git
   cd terraform-nginx-deployment

## Initialize Terraform:
- terraform init
## Plan the deployment:
- terraform plan
## Apply the configuration:
-terraform apply

## This setup will deploy your Dockerized web application on AWS, configure it to use an S3 bucket for storage, front it with a CloudFront CDN, manage the domain with Route 53, and implement auto-scaling for efficient resource management.


