#!/bin/bash

if [ ! $(minikube status | grep "host: Running" | wc -l) -eq 1 ]; then
  minikube start
fi

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f build/argo-resources/argocd-clusterrole.yaml
kubectl apply -f build/argo-resources/argocd-clusterrolebinding.yaml

# Wait for ArgoCD server to be ready
echo "Waiting for ArgoCD server to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
kubectl wait --for=condition=available --timeout=300s deployment/argocd-repo-server -n argocd

# Port forward ArgoCD API server. Ampersand ensures script continues.
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

# Get the ArgoCD admin password
ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Login to ArgoCD
argocd login localhost:8080 --username admin --password $ARGO_PWD --insecure

# Create the argo app
kubectl apply -f build/argo-resources/argocd-app.yaml

#argocd app create argocd-app \
#   --repo https://github.com/jalbritt/argocd-example \
#   --path build/argo-resources \
#   --dest-server https://kubernetes.default.svc \
#   --dest-namespace argocd \
#   --sync-policy automated

# Create the standalone app
kubectl apply -f demos/standalone-app/standalone-app.yaml

#argocd app create standalone-app \
#    --repo https://github.com/jalbritt/argocd-example \
#    --path demos/standalone-app/hello-world \
#    --dest-server https://kubernetes.default.svc \
#    --dest-namespace argocd \
#    --sync-policy automated

# Create the app-of-apps
# kubectl apply -f demos/app-of-apps/app-of-apps.yaml
argocd app create app-of-apps \
    --repo https://github.com/jalbritt/argocd-example \
    --path demos/app-of-apps \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace argocd \
    --sync-policy automated

echo "ArgoCD setup complete. Access the UI at http://localhost:8080"
echo "Username: admin"
echo "Password: $ARGO_PWD"
