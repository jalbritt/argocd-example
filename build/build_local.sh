#!/bin/bash

# Start Minikube
minikube start

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f build/argo-resources/argocd-clusterrole.yaml
kubectl apply -f build/argo-resources/argocd-clusterrolebinding.yaml

# Wait for ArgoCD server to be ready
echo "Waiting for ArgoCD server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Port forward ArgoCD API server
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
sleep 5

# Get the ArgoCD admin password
ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Login to ArgoCD
argocd login localhost:8080 --username admin --password $ARGO_PWD --insecure

# Create the argo app
argocd app create argocd \
   --repo https://github.com/jalbritt/argocd-example \
   --path build/argo-resources \
   --dest-server https://kubernetes.default.svc \
   --dest-namespace argocd \
   --sync-policy automated

# Create the standalone app
argocd app create standalone-app \
    --repo https://github.com/jalbritt/argocd-example \
    --path demos/standalone-app \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argocd \
    --sync-policy automated

# Create the app-of-apps
argocd app create app-of-apps \
    --repo https://github.com/jalbritt/argocd-example \
    --path demos/app-of-apps \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argocd \
    --sync-policy automated

echo "ArgoCD setup complete. Access the UI at http://localhost:8080"
echo "Username: admin"
echo "Password: $ARGO_PWD"
