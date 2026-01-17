# Multi-Region K8s Platform (AWS EKS)

A production-grade, highly available Kubernetes platform deployed across two AWS regions (Singapore and Ireland) using Terraform.

## 🚀 Project Overview
This project demonstrates the deployment of a resilient, multi-region infrastructure including:
- **Compute:** AWS EKS (Elastic Kubernetes Service) with managed node groups.
- **Networking:** Custom VPCs with public/private subnet isolation and NAT Gateways.
- **Storage:** RDS PostgreSQL for relational data.
- **Caching:** AWS ElastiCache (Redis) for high-speed data access.

## 🏗️ Architecture
The infrastructure is modularized to ensure consistency across regions:
- `modules/network`: VPC, Subnets, and Gateways.
- `modules/database`: RDS and Redis configurations.
- `envs/`: Regional implementation (Asia Pacific & Europe).



## 🛠️ Tech Stack
- **IaC:** Terraform
- **Cloud:** AWS (EKS, RDS, ElastiCache, VPC)
- **Container Orchestration:** Kubernetes (kubectl)

## 🚦 Getting Started
1. **Initialize:** `terraform init` within the `envs/<region>` folder.
2. **Plan:** `terraform plan` to verify resources.
3. **Deploy:** `terraform apply -auto-approve`

## 🚧 Status: Active Development
Currently finalizing regional failover testing and application-level secrets management.