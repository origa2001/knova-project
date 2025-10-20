
Knova DevOps/Infrastructure Engineer Exercise

This folder contains my work for the Knova assessment.

Assumptions

- Short timebox: focus on automation, structure, and documentation rather than fully productionized delivery.

Plan (high level)
1) Terraform: scaffold to provision network, bastion, compute, storage, and managed Postgres (parameterized by environment).
2) Helm: chart that deploys a simple containerized API (Hello World) supporting HA and rolling updates.
3) CI: GitHub Actions workflows to build, test, and deploy (dev auto; staging/prod with approvals).
4) Security: document secrets approach and provide examples for parameterized secrets.
5) Monitoring (optional): Prometheus/Grafana basics and one alert rule.

Next steps
- Add Terraform scaffold in `terraform/` (I will implement variables, provider, VPC, bastion, rds, and example compute).
- Add Helm chart skeleton in `helm/` with a simple app image and values for replicas, resources, probes.
- Add CI workflows in `ci/` and in `.github/workflows/` (build/test/deploy).

CI / CD (current)
- A GitHub Actions workflow has been added at `.github/workflows/ci-cd.yaml` which:
	- Builds the `sample-app` Docker image and pushes it to GitHub Container Registry (GHCR).
	- Deploys the Helm chart to a Kubernetes cluster using a provided base64-encoded `KUBECONFIG` secret.
	- Runs the `ci/smoke_test.sh` script after deployment.
	- Protects the `production` deployment behind the `production` environment (you can require approvals in GitHub).

Required repository secrets for CI (set these in GitHub > Settings > Secrets):
- `KUBECONFIG` - base64-encoded kubeconfig for the cluster used for dev deployments (optional if using local minikube only).
- `KUBECONFIG_PROD` - base64-encoded kubeconfig for production cluster (optional; used for production deployment job).

Using minikube locally (recommended for demo / cost-free testing)
1. Install and start minikube (driver docker):

```bash
minikube start --driver=docker
```

2. Build the image and load it into minikube (so the cluster can run the image locally):

```bash
# from repository root
docker build -t sample-app:latest ./sample-app
minikube image load sample-app:latest
```

3. Deploy the Helm chart locally:

```bash
helm upgrade --install sample-app helm/sample-app -n sample-app --create-namespace --set image.repository=sample-app,image.tag=latest
kubectl get pods,svc -n sample-app
kubectl port-forward svc/sample-app-sample-app 8080:8080 -n sample-app
```

4. If you want the GitHub Actions workflow to deploy into your minikube cluster automatically (for CI runs), create a base64-encoded kubeconfig and add it as a repository secret:

```bash
# On your machine where kubectl is configured for minikube
base64 < ~/.kube/config | pbcopy    # macOS: copies encoded kubeconfig to clipboard
# then create a repo secret named KUBECONFIG with that value
```

Notes & tradeoffs
- This workspace intentionally uses `minikube` for local, cost-free Kubernetes testing instead of provisioning EKS (to avoid cloud costs).
- The Terraform in `terraform/` currently provisions VPC, subnets, bastion, and RDS but does not create an EKS cluster — you can either use local minikube for demos or I can add EKS Terraform later if you want a fully-cloud deployment.
- Do not use default values for `allow_ssh_cidr` or `key_name` in production. Lock SSH access to a known CIDR and provide a valid EC2 key pair name.

