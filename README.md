# Project Overview

This repository contains a full-stack application with a robust infrastructure-as-code setup using Terraform. Below is a summary of the architecture and CI/CD flow:


- **VPC**: Custom Virtual Private Cloud for network isolation. Resources like ECS, MongoDB are deployed in private subnets with no direct connection to the internet.
- **Security Groups**: A standalone module. After networking is created (to provide the VPC ID), the security group module is deployed. Its output (the SG ID) is then passed to both the backend and MongoDB modules to enforce strict communication rules:
	- ALB and ECS communicate only through a dedicated SG.
	- MongoDB and ECS communicate only through a dedicated SG.
- **MongoDB on EC2**: Database runs on an EC2 instance within the VPC. AWS SSM agent is installed on all EC2 instances for secure, auditable connections (no SSH exposure).
- **Secrets Management**: MongoDB password is generated and stored in AWS Secrets Manager, and securely passed as a secret to the ECS task at runtime. Secret created manually as to not have the password in terraform's state.
- **ECS Cluster**: Hosts the application server as a container. The ECS service is set to 0 tasks by default; the CI pipeline can scale it up as needed. An Auto Scaling Group (ASG) is configured to scale ECS tasks based on CPU load.
- **ALB (Application Load Balancer)**: Exposes the ECS service to the internet.
- **S3 (Client HTML)**: Stores the static client files.
- **CloudFront (CF)**: Distributes content with two origins: the ALB (for API) and the client S3 bucket. CloudFront handles routing between them. The client S3 serves `/index.html` and calls the API at `/api/v2/todos`.
- **Route53 (R53)**: DNS management, exposing all services. NS records are added to Namecheap for domain delegation.
- **Strict Least Privilege**: All resources and IAM roles are configured with least privilege, including OIDC setup for GitHub Actions in `infra/gh_oidc`.

> All calls from AWS services to other AWS services (e.g., S3, ECR, SSM) are routed through VPC endpoints (VPCE), as there is no NAT gateway deployed. This ensures private connectivity for all service integrations.


## Deployment Order
1. **Networking**: Run `terraform init` and `terraform apply` in the `infra/networking` directory to create the VPC and networking resources.
2. **Pass VPC ID**: Take the VPC ID output and pass it as a variable to both the `mongodb` and `backend` modules.
3. **Deploy MongoDB and Backend**: Deploy `infra/mongodb` and `infra/backend` with the VPC ID. After deploying, take the `ecs_service_sg_id` (ECS security group ID) output from the backend.
4. **Update MongoDB SG**: Pass the `ecs_service_sg_id` to the MongoDB module and re-apply. This ensures only ECS tasks can communicate with MongoDB.
5. **S3 and CloudFront**: Deploy the S3 bucket and CloudFront distribution first, without passing ACM or ALB DNS names. This allows the static client to be available and CloudFront to be set up with basic configuration.
6. **ACM and ALB**: Deploy ACM (certificate) and ALB. After ACM is validated and ALB is available, update CloudFront and S3 with the ACM and ALB DNS names as needed.
7. **Route53**: Deploy `infra/route53` to create DNS records. Take the NS records and add them to your DNS provider (e.g., Namecheap).

This process ensures secure, private networking, strict access controls, and correct dependency flow between all components.

## Application Code (`application_code/`)
- **Client**: Simple static client (HTML/JS), with a Dockerfile and `.dockerignore` for slim images.
- **Server**: Node.js/Express API, with a Dockerfile and `.dockerignore`. Includes tests (`npm test`) that create/modify todos and require a DB (MongoDB). Tests are run in the CI flow.

## CI/CD Workflows (`.github/workflows/`)
- **Server**: Builds Docker image, runs tests against a MongoDB instance deployed in the CI pipeline, pushes the image to ECR, and updates the ECS task. On first run, scales the service to 1; on subsequent runs, updates the image and forces a new deployment.
- **Client**: Deploys static files to S3 and invalidates the CloudFront cache for `/index.html`.

---

This setup ensures a secure, scalable, and automated deployment pipeline for both the backend and frontend, with clear separation of concerns and minimal privileges for all resources.
