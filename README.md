Flask Notes – EKS Deployment (Terraform + GitHub Actions)
This repository contains a production-style DevOps implementation of a Flask web application deployed on AWS EKS, using Terraform for infrastructure provisioning and GitHub Actions for CI/CD.

The focus of this project is infrastructure design, automation, and deployment workflows, not application feature development.

🏗️ Architecture Overview
scss
￼Copy code
GitHub Actions
   │
   ├── Terraform (S3 + DynamoDB backend)
   │     ├── VPC
   │     ├── EKS Cluster + Managed Node Group
   │     ├── RDS MySQL (private subnets)
   │     └── ECR Repository
   │
   └── Kubernetes (EKS)
         ├── DB migration Job
         ├── Flask Deployment
         └── LoadBalancer Service
📁 Repository Structure
graphql
￼Copy code
.
├── terraform/
│   ├── backend/        # S3 + DynamoDB for Terraform remote state
│   ├── ecr/            # ECR repository for Docker images
│   ├── Eks/            # VPC + EKS cluster + node group
│   └── rds/            # RDS MySQL (private, not public)
│
├── deployments/
│   ├── flask-deployment.yml   # Flask application Deployment
│   ├── flask-service.yml      # LoadBalancer Service
│   ├── db-migrate-job.yml     # One-time DB initialization Job
│   └── rds-secrets.yml        # Kubernetes Secret (current state)
│
├── .github/workflows/
│   ├── terraform-backend-apply.yml
│   ├── terraform-ecr-apply.yml
│   ├── terraform-eks-apply.yml
│   ├── terraform-rds-apply.yml
│   ├── terraform-*-destroy.yml
│   ├── ecr-push.yml
│   └── k8s.yml
│
└── README.md
🚀 What This Project Currently Does

Infrastructure (Terraform)
Creates an S3 backend with DynamoDB state locking
Provisions a custom VPC with public & private subnets
Deploys an EKS cluster with managed node groups
Creates a private RDS MySQL instance
Creates an ECR repository with image lifecycle policies
Uses separate Terraform states per component
CI/CD (GitHub Actions)
Manually triggered workflows (workflow_dispatch)

Terraform:

Plan & apply per stack (backend, ECR, EKS, RDS)
Independent destroy workflows
Application:
Build Docker image
Push image to ECR
Deploy to EKS
Run DB migration job before app deployment

Kubernetes

Flask app deployed as a Deployment
DB schema initialized via a Kubernetes Job
Exposed using a LoadBalancer Service
Environment variables injected via Kubernetes Secret


🛠️ Deployment Order (Required)

Infrastructure must be created in this order:
Terraform backend (S3 + DynamoDB)
ECR repository
EKS cluster
RDS database
Build & push Docker image

Deploy to Kubernetes

📌 How to Deploy (High-Level)

1. Configure GitHub Secrets

Required secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REPOSITORY
TF_VAR_db_password

2. Run Terraform Workflows
Trigger workflows manually from GitHub Actions:

terraform-backend-apply
terraform-ecr-apply
terraform-eks-apply
terraform-rds-apply

3. Build & Push Image
Run:
ecr-push.yml

4. Deploy to Kubernetes
Run:
k8s.yml

🧪 Database Migration Strategy
Database schema is created using a Kubernetes Job

The job runs:

python
db.create_all()
Job is deleted and recreated on every deployment
Application deployment happens only after job completion

This ensures:
DB exists before app starts
No race conditions on first deploy

