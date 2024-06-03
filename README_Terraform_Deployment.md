
# AWS Dockerized Web Application Deployment with Terraform

This project sets up a Dockerized web application on AWS using Terraform. It integrates various AWS services such as EC2, S3, CloudFront, Auto-scaling, and Route 53 to create a scalable, high-performance web infrastructure.
/terraform-nginx-deployment
│
├── main.tf          # Main Terraform configuration
├── variables.tf     # Terraform variables
├── outputs.tf       # Terraform outputs
├── provider.tf      # Provider configuration
│
├── .gitignore       # Specifies intentionally untracked files to ignore
└── README.md        # Detailed project documentation
## Project Architecture

- **EC2 Instance**: Hosts the Docker container for the web application.
- **S3 Bucket**: Used for storing user-uploaded files.
- **CloudFront Distribution**: Distributes the web application content globally to reduce latency.
- **Auto-Scaling Group**: Manages the scaling of EC2 instances based on load.
- **Route 53**: Manages DNS records for the application, directing traffic to the CloudFront distribution.

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed on your machine

## Environment Variables Configuration

Environment variables are crucial for integrating the Docker container with AWS services. They are set in the `aws_instance` resource in `main.tf` using the `user_data` attribute. The following variables are configured:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET_NAME`
- `AWS_REGION`

## Deployment Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/harvinder31/terraform-nginx-deployment
   ```

2. Navigate to the project directory and initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the Terraform configuration to deploy the infrastructure:
   ```bash
   terraform apply
   ```

4. Confirm the changes and execute the deployment.

## Special Considerations

- Ensure the AWS credentials used have the minimal necessary permissions for security best practices.
- Monitor CloudFront costs, as global distribution can incur higher charges.
- Adjust auto-scaling settings based on expected traffic patterns to optimize costs.

## GitHub Repository

All necessary Terraform scripts and the README are available at:
https://github.com/harvinder31/terraform-nginx-deployment

