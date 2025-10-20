Helm chart for sample-app

To test locally you can use either `minikube`, `kind`, or any local Kubernetes cluster.

Quick Local Flow (minikube):
1. Start minikube: `minikube start --driver=docker`
2. Build image and load into minikube:
   - `docker build -t sample-app:latest ./knova-exercise/sample-app`
   - `minikube image load sample-app:latest`
3. Install the chart:
   - `helm upgrade --install sample-app ./knova-exercise/helm/sample-app -n sample-app --create-namespace`
4. Check service:
   - `kubectl get pods,svc -n sample-app`
   - `kubectl port-forward svc/sample-app-sample-app 8080:8080 -n sample-app` (adjust name if needed)

Or with `kind`:
1. Create a kind cluster
2. Build and load image into kind: `docker build -t sample-app:latest ./knova-exercise/sample-app` then `kind load docker-image sample-app:latest --name <cluster-name>`
3. Deploy the chart as above.

This keeps costs zero and demonstrates Helm + local Kubernetes deployment.
