
---

# 📕 RUNBOOK.md

```md
# RUNBOOK – Multi-Region Kubernetes GitOps Platform

## Purpose
This runbook describes **operational procedures** for managing,
verifying, and troubleshooting the multi-region Kubernetes platform.

---

## 1. Cluster Verification

Check available EKS clusters:
```bash
aws eks list-clusters --region us-east-1
aws eks list-clusters --region eu-west-1
aws eks list-clusters --region ap-southeast-1
Update kubeconfig:

aws eks update-kubeconfig --region us-east-1 --name mrk8s-us-east-1


Verify nodes:

kubectl get nodes -o wide

2. Argo CD Health Check

Check Argo CD components:

kubectl get pods -n argocd


Check application status:

argocd app list
argocd app get project-app


Expected:

Sync Status: Synced

Health Status: Healthy

3. GitOps Validation
Pod Self-Healing Test
kubectl delete pod -l app=demo-app
kubectl get pods


Result: Pods are recreated automatically.

Scaling via Git

Modify replicas in deployment.yaml

Commit & push to Git

Argo CD syncs automatically

4. Application Access

Check service:

kubectl get svc


Access application:

curl http://<LOAD_BALANCER_DNS>

5. Common Issues & Fixes
Application OutOfSync
argocd app sync project-app

Permission Errors

Ensure:

Correct Argo CD login

Correct kube-context

Cluster added using argocd cluster add

6. Disaster Recovery Notes

Git repository is the source of truth

Clusters can be recreated using Terraform

Applications restored automatically via Argo CD

7. Safe Cleanup

Destroy infrastructure:

terraform destroy


Confirm no active resources remain in AWS console.