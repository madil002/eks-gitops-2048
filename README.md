# EKS-GitOps-2048

## 🏗️ Architecture Diagram:

<p align="center">
  <img src="images/arch_diagram.gif" alt="architechtural diagram" style="width:800px"/>
</p>

## 📁 Project Structure
```
└── ECS-URL-SHORTENER
    ├── pre-commit-config.yaml
    ├── app/
    ├── terraform/
    │    ├── backend.tf
    │    ├── main.tf
    │    ├── provider.tf
    │    ├── variables.tf
    │    └── modules/
    │        ├── EKS/
    │        ├── VPC/
    │        ├── nodegroup/
    │        ├── pod-identity/
    │        └── helm/
    └── .github/workflows/
           ├── 
           ├── 
           └── docker-build-push.yaml
```

## 🏗️ Architecture
#### Key Components:

- **ECS Fargate**: Runs Python app containers inside private subnets for secure, scalable compute.
- **AWS WAF**: Protects against malicious input using AWS Managed Rules.
- **CodeDeploy**: Enables blue/green deployments with automatic rollback on health check failures.
- **GitHub Actions + OIDC**: Implements secure CI/CD pipelines without long-lived AWS credentials.
- **VPC Endpoints**: Provides private access to AWS services, avoiding NAT gateway costs.
- **DynamoDB**: Stores short-to-long URL mappings with pay-per-request billing and point-in-time recovery (PITR).
- **Application Load Balancer (ALB)**: Handles HTTPS termination, routing, and health checks.
- **ACM + Route 53**: Issues TLS certificates and maps a custom domain
- **Code & Container Security**:
    - **Pre-Commit Hooks & Linting →** Terraform code is automatically formatted and validated before any commit, catching syntax errors and misconfigurations early
    - **Checkov →** Scans Terraform infrastructure for policy violations and security misconfigurations, ensuring compliance before deployment
    - **Trivy →** Scans container images for critical and high-severity vulnerabilities before they are pushed to ECR, preventing insecure images from reaching production
