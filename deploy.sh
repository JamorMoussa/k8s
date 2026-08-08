#!/usr/bin/env bash
set -e

# Use k3s kubeconfig if readable and KUBECONFIG is not set
if [ -z "$KUBECONFIG" ] && [ -r "/etc/rancher/k3s/k3s.yaml" ]; then
  export KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
fi

echo "🚀 Deploying application stack to Kubernetes..."

# 1. Apply Namespace, ConfigMap, and Secret first
echo "📦 Applying Namespace, ConfigMap, and Secret..."
kubectl apply -f k8s-manifests/book_namespace.yaml
kubectl apply -f k8s-manifests/book_configmap.yaml
kubectl apply -f k8s-manifests/book_postgres_cred.yaml

# 2. Deploy PostgreSQL via Helm using postgres-secret
echo "🐘 Installing/updating PostgreSQL via Helm..."
helm upgrade --install postgresql oci://registry-1.docker.io/bitnamicharts/postgresql \
  --namespace book-store \
  -f k8s-manifests/postgres-values.yaml

# Wait for PostgreSQL to be ready before starting backend
echo "⏳ Waiting for PostgreSQL pod to be ready..."
kubectl rollout status statefulset/postgresql -n book-store --timeout=120s

# 3. Apply application manifests
echo "📦 Applying application manifests..."
kubectl apply -f k8s-manifests/book_deployment.yaml
kubectl apply -f k8s-manifests/book_service.yaml

# 4. Wait for deployment rollout
echo "⏳ Waiting for deployment rollout..."
kubectl rollout status deployment/book-deployment -n book-store --timeout=90s

# 5. Show status
echo "✅ Deployment completed! Current resources in 'book-store' namespace:"
kubectl get all -n book-store
