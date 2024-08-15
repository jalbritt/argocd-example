# Example ArgoCD Configurations
This repo contains boilerplate configurations for ArgoCD. Try them out yourself locally using minikube. Just clone the repo and execute thebuild_local.sh script. The script will install minikube, kubectl, and argocd, and then deploy the specified configurations to minikube. Once the argocd server is running, you can access the ArgoCD UI by running the following command by following the link from the output of the build script and using the provided username and password to login.

.
├── README.md
├── build
│   ├── argo-resources
│   │   ├── argocd-app.yaml
│   │   ├── argocd-clusterrole.yaml
│   │   ├── argocd-clusterrolebinding.yaml
│   │   └── argocd-ns.yaml
│   └── build_local.sh
├── demos
│   ├── app-of-apps
│   │   ├── app-of-apps.yaml
│   │   ├── database
│   │   │   ├── database-ns.yaml
│   │   │   ├── kustomization.yaml
│   │   │   ├── postgres-deployment.yaml
│   │   │   ├── postgres-pv.yaml
│   │   │   ├── postgres-pvc.yaml
│   │   │   └── postgres-service.yaml
│   │   ├── kustomization.yaml
│   │   ├── monitoring
│   │   │   ├── kustomization.yaml
│   │   │   ├── monitoring-deployment.yaml
│   │   │   ├── monitoring-ns.yaml
│   │   │   └── monitoring-service.yaml
│   │   └── server
│   │       ├── kustomization.yaml
│   │       ├── server-deployment.yaml
│   │       ├── server-ns.yaml
│   │       └── server-service.yaml
│   └── standalone-app
│       ├── hello-world
│       │   ├── hello-world-deployment.yaml
│       │   ├── hello-world-ns.yaml
│       │   ├── hello-world-service.yaml
│       │   └── kustomization.yaml
│       ├── kustomization.yaml
│       └── standalone-app.yaml
└── generate_output.sh
10 directories, 29 files

The first feature you can check yourself is ArgoCD's ability to sync the state of the cluster with the desired state defined in the git repository. You can see this by changing the desired state in the git repository and then syncing the application in the ArgoCD UI. The application will be updated to match the desired state. Another way to demonstrate this is to manually change the configuration using kubectl. Immediately ArgoCD will detect the drift and update the application to match the desired state. This prevents errors from manual changes and ensures that the desired state is always maintained.

Another useful feature is the ability to use the "app of apps" pattern. This allows you to define a single application that manages all other applications. This is useful for managing multiple applications in a single repository. This is shown in the directory /demos/app-of-apps in this project.


