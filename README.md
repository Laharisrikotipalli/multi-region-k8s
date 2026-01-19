
# Multi-Region Kubernetes Platform with GitOps (Argo CD)

This project demonstrates a multi-region Kubernetes platform on AWS using Terraform, Amazon EKS, and GitOps with Argo CD.
A containerized FastAPI application is deployed and managed declaratively using Git as the single source of truth.

---

## Project Goals

Provision multiple Kubernetes clusters across regions

Use Terraform (IaC) for all infrastructure

Implement GitOps using Argo CD

Deploy and manage applications declaratively

Demonstrate self-healing and scaling via Git

Provision regional PostgreSQL and Redis infrastructure

---

## Architecture Overview

The platform consists of:

Independent EKS clusters per AWS region

Argo CD managing application state

GitHub repository as the source of truth

A FastAPI demo application

PostgreSQL and Redis provisioned per region via Terraform

---

## Architecture diagram:
![img](docs/architecture.png)

---

## AWS Regions Used
**Region	Purpose**
us-east-1	Primary cluster
eu-west-1	Secondary cluster
ap-southeast-1	Secondary cluster

Each region is deployed independently.

---

## Technology Stack
Layer	Tool
Cloud	AWS
Kubernetes	Amazon EKS
Infrastructure as Code	Terraform
GitOps	Argo CD
Application	FastAPI
Containerization	Docker
Database	PostgreSQL (RDS)
Cache	Redis (ElastiCache)

---

## Repository Structure
```
multi-region-k8s/
├── docs/
│   └── architecture.png
├── fastapi/
│   ├── Dockerfile
│   └── main.py
├── k8s/
│   └── app.yaml
├── terraform/
│       ├── envs/
│         ├── us-east-1/
│         ├── eu-west-1/
│         └── ap-southeast-1/
├── screenshots/
├── project-app.yaml
├── submission.yml
└── README.md
```
---

## Infrastructure Provisioning (Terraform)

**Terraform provisions the following per region:**

VPC, subnets, routing

EKS cluster

IAM roles and node groups

PostgreSQL (RDS)

Redis (ElastiCache)

**Example:**
```
cd terraform/envs/us-east-1
```
```
terraform init
```
```
terraform apply
```
---

**All infrastructure is reproducible and region-isolated.**

## Data Layer (PostgreSQL & Redis)
**What Was Implemented**

- PostgreSQL and Redis are provisioned in each region using Terraform modules

- Each region has independent database instances

- No cross-region replication is configured (by design)

Region	PostgreSQL	Redis
us-east-1	✅ Provisioned	✅ Provisioned
eu-west-1	✅ Provisioned	✅ Provisioned
ap-southeast-1	✅ Provisioned	✅ Provisioned
**Important Clarification (Intentional Design)**

The FastAPI demo application does NOT depend on PostgreSQL or Redis at runtime.

Databases were provisioned to demonstrate infrastructure capability

The application runs independently for GitOps, scaling, and self-healing demos

Any observed database connection errors in logs are non-blocking and expected

No application functionality depends on successful DB connectivity

This separation ensures the demo remains stable while still validating multi-region data infrastructure provisioning.

---
## GitOps with Argo CD

Argo CD is used to:

Watch this GitHub repository

Sync Kubernetes manifests from /k8s

Enforce desired state automatically

Reconcile drift and recreate deleted resources

---

## Application Deployment (FastAPI)

FastAPI app is containerized using Docker

Deployed via Kubernetes Deployment

Exposed via LoadBalancer / NodePort

Health endpoint available at /health

**Sample response:**
```
{
  "app": "FastAPI GitOps Demo",
  "pod": "fastapi-app-xxxx",
  "region": ""
}
```
---

## GitOps Proof (Demonstrated)
Automated Sync

***Changes pushed to Git**

Argo CD auto-synced cluster state

***Self-Healing***
```
kubectl delete pod -l app=demo-app

```
Pods were recreated automatically.

***Scaling via Git***

Replica count changed in Git

Argo CD applied scaling automatically

---
## Multi-Cluster Management

All clusters were registered with Argo CD:

***argocd cluster list***

Clusters:

In-cluster

us-east-1

eu-west-1

ap-southeast-1

## Cleanup (Cost Safe)

All resources can be removed using:

```
terraform destroy
```

Ensures no AWS costs remain.


🔗 Repository

https://github.com/Laharisrikotipalli/multi-region-k8s
