
ArgoCD Short Tutorial (Most Important Activities)

ArgoCD is a GitOps tool for Kubernetes/OpenShift. It continuously syncs Kubernetes manifests from Git into your cluster.

Core idea:

    Git = source of truth
    ArgoCD watches Git
    Changes are automatically deployed to Kubernetes/OpenShift


Typical workflow:

    Developer updates YAML/Helm chart in Git
    ArgoCD detects changes
    ArgoCD syncs cluster automatically
    Drift is corrected if cluster differs from Git


Prerequisites:

    Kubernetes or OpenShift cluster
    kubectl or oc
    Git repository

    Install ArgoCD


Kubernetes:

kubectl create namespace argocd

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


OpenShift:

oc new-project argocd

oc apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


Check pods:

kubectl get pods -n argocd

    Access ArgoCD UI


Port forward:

kubectl port-forward svc/argocd-server -n argocd 8080:443


Open:

https://localhost:8080


Get admin password:

kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d


Login:

    User: admin
    Password: output above

    Create a Simple App


Example Git repo structure:

my-app/
 ├── deployment.yaml
 ├── service.yaml
 └── namespace.yaml


Example deployment:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

    Create ArgoCD Application


CLI example:

argocd app create nginx-app \
  --repo https://github.com/example/my-app.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default


Sync application:

argocd app sync nginx-app


Check status:

argocd app get nginx-app

    Enable Auto-Sync


This is one of the most important production features.

argocd app set nginx-app --sync-policy automated


Optional self-healing:

argocd app set nginx-app \
  --self-heal \
  --auto-prune


What this does:

    Auto deploy Git changes
    Revert manual cluster changes
    Remove deleted resources automatically

    Rollback Application


View history:

argocd app history nginx-app


Rollback:

argocd app rollback nginx-app <revision>


Very important in production environments.

    Use Helm with ArgoCD


ArgoCD commonly deploys Helm charts.

Example:

argocd app create prometheus \
  --repo https://github.com/prometheus-community/helm-charts.git \
  --path charts/kube-prometheus-stack \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace monitoring


Key interview point:

ArgoCD supports:

    Plain YAML
    Helm
    Kustomize

    GitOps Best Practices


Recommended structure:

gitops-repo/
 ├── dev/
 ├── test/
 └── prod/


Best practices:

    Separate environments
    Use pull requests
    Never edit cluster manually
    Store manifests in Git
    Use RBAC
    Use secrets management tools

    Common Troubleshooting


Check application status:

argocd app list


Describe app:

argocd app get nginx-app


Check controller logs:

kubectl logs deployment/argocd-application-controller -n argocd


Common issues:

    Git authentication failure
    Wrong namespace
    Invalid YAML
    Missing RBAC permissions
    Sync stuck in OutOfSync state

    Important Interview Topics


You should be able to explain:

What is GitOps?

    Git is the single source of truth


Why use ArgoCD?

    Automated deployments
    Drift detection
    Rollbacks
    Auditability


Difference between push vs pull deployment?

    ArgoCD uses pull model


What is drift detection?

    ArgoCD detects manual cluster changes


How do you manage secrets?

    Vault
    Sealed Secrets
    External Secrets Operator

    Most Important Production Features


Focus on understanding these:

    Auto-sync
    Self-healing
    Rollbacks
    RBAC
    Multi-environment deployment
    Helm integration
    Drift detection
    Application health monitoring

    Very Common Enterprise Setup


Typical real-world flow:

Developer Pushes Code
        ↓
CI Pipeline Builds Image
        ↓
Helm Values Updated in Git
        ↓
ArgoCD Detects Change
        ↓
OpenShift/Kubernetes Updated
        ↓
Monitoring + Alerts Validate Deployment


This is the exact kind of workflow many OpenShift platform teams implement.