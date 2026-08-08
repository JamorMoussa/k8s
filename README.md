# k8s

FastAPI book management service built with `uv` and `SQLModel`.

## Quick Start (Docker)

```bash
# Build
docker build -t k8s-app .

# Run
docker run -p 8000:8000 -e DATABASE_URL="sqlite:///./db/app.db" k8s-app
```

## Local Development

```bash
uv sync
DATABASE_URL="sqlite:///./db/app.db" uv run uvicorn main:app --reload
```

## API Endpoints

- `POST /api/v1/book/create`
- `GET /api/v1/book/books`
- `GET /api/v1/book/books/{book_id}`


## Docker Hub

### Login
docker login -u <username> 
[PASSWORD]

### Push
docker build -t k8s-app .
docker tag k8s-app:latest <username>/k8s-app:latest
docker push <username>/k8s-app:latest

## setup k3s cluster
```bash
curl -sfL https://get.k3s.io | sh - 
# Check for Ready node, takes ~30 seconds 
sudo k3s kubectl get node 
```

## fix permission
sudo chmod 644 /etc/rancher/k3s/k3s.yaml


## Intall helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm install postgresql oci://registry-1.docker.io/bitnamicharts/postgresql --namespace=book-store

