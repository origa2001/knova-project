#!/usr/bin/env bash
# Simple smoke test for sample-app deployed with Helm
set -euo pipefail
NAMESPACE=${1:-sample-app}
SERVICE_NAME=${2:-sample-app-sample-app}
PORT=${3:-8080}

# Wait for service to get cluster IP
echo "Waiting for service ${SERVICE_NAME} in namespace ${NAMESPACE}..."
for i in {1..30}; do
  IP=$(kubectl get svc ${SERVICE_NAME} -n ${NAMESPACE} -o jsonpath='{.spec.clusterIP}' || true)
  if [[ -n "$IP" && "$IP" != "<none>" ]]; then
    echo "Found service IP: $IP"
    break
  fi
  sleep 1
done

# Curl the service via port-forward in background
kubectl port-forward svc/${SERVICE_NAME} ${PORT}:${PORT} -n ${NAMESPACE} >/dev/null 2>&1 &
PF_PID=$!
sleep 1

# Try /health
for i in {1..10}; do
  if curl -sSf "http://localhost:${PORT}/health" | grep -q "ok"; then
    echo "Smoke test passed"
    kill $PF_PID || true
    exit 0
  fi
  sleep 1
done

kill $PF_PID || true
echo "Smoke test failed"
exit 1
