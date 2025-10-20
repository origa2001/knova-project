
Knova DevOps/Infrastructure Engineer Exercise

This folder contains my work for the Knova assessment.

Assumptions
- Working path: knova-exercise at repository root: /Users/origa/Desktop/DevOps Stuff/US-Mobile-project/knova-exercise
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

If you'd like a different folder name or location, tell me now; otherwise I'll proceed implementing the Terraform scaffold next.
