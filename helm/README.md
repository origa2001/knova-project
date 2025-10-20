Helm chart for the sample API

I'll create a chart that deploys a Hello World API with:
- Deployment with configurable replicas
- Service (ClusterIP/LoadBalancer configurable)
- Readiness and Liveness probes
- Values.yaml for image/tag, resources, and rolling update strategy
