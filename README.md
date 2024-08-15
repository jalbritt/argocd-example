# Example ArgoCD Configurations
This repo contains boilerplate configurations for ArgoCD. Try them out yourself locally using minikube. Just clone the repo and execute thebuild_local.sh script. The script will install minikube, kubectl, and argocd, and then deploy the specified configurations to minikube. Once the argocd server is running, you can access the ArgoCD UI by running the following command by following the link from the output of the build script and using the provided username and password to login.

.
|-- ./generate_output.sh
|-- ./demos
|   |-- ./demos/standalone-app
|   |   |-- ./demos/standalone-app/kustomization.yaml
|   |   |-- ./demos/standalone-app/hello-world
|   |   |   |-- ./demos/standalone-app/hello-world/kustomization.yaml
|   |   |   |-- ./demos/standalone-app/hello-world/hello-world-ns.yaml
|   |   |   |-- ./demos/standalone-app/hello-world/hello-world-deployment.yaml
|   |   |   `-- ./demos/standalone-app/hello-world/hello-world-service.yaml
|   |   `-- ./demos/standalone-app/standalone-app.yaml
|   `-- ./demos/app-of-apps
|       |-- ./demos/app-of-apps/kustomization.yaml
|       |-- ./demos/app-of-apps/monitoring
|       |   |-- ./demos/app-of-apps/monitoring/monitoring-service.yaml
|       |   |-- ./demos/app-of-apps/monitoring/monitoring-deployment.yaml
|       |   |-- ./demos/app-of-apps/monitoring/monitoring-ns.yaml
|       |   `-- ./demos/app-of-apps/monitoring/kustomization.yaml
|       |-- ./demos/app-of-apps/server
|       |   |-- ./demos/app-of-apps/server/server-deployment.yaml
|       |   |-- ./demos/app-of-apps/server/server-service.yaml
|       |   |-- ./demos/app-of-apps/server/server-ns.yaml
|       |   `-- ./demos/app-of-apps/server/kustomization.yaml
|       |-- ./demos/app-of-apps/app-of-apps.yaml
|       `-- ./demos/app-of-apps/database
|           |-- ./demos/app-of-apps/database/postgres-pv.yaml
|           |-- ./demos/app-of-apps/database/postgres-pvc.yaml
|           |-- ./demos/app-of-apps/database/postgres-service.yaml
|           |-- ./demos/app-of-apps/database/postgres-deployment.yaml
|           |-- ./demos/app-of-apps/database/database-ns.yaml
|           `-- ./demos/app-of-apps/database/kustomization.yaml
|-- ./build
|   |-- ./build/argo-resources
|   |   |-- ./build/argo-resources/argocd-clusterrolebinding.yaml
|   |   |-- ./build/argo-resources/argocd-clusterrole.yaml
|   |   |-- ./build/argo-resources/argocd-ns.yaml
|   |   `-- ./build/argo-resources/argocd-app.yaml
|   `-- ./build/build_local.sh
`-- ./README.md
10 directories, 29 files

The first feature you can check yourself is ArgoCD's ability to sync the state of the cluster with the desired state defined in the git repository. You can see this by changing the desired state in the git repository and then syncing the application in the ArgoCD UI. The application will be updated to match the desired state. Another way to demonstrate this is to manually change the configuration using kubectl. Immediately ArgoCD will detect the drift and update the application to match the desired state. This prevents errors from manual changes and ensures that the desired state is always maintained.

Another useful feature is the ability to use the "app of apps" pattern. This allows you to define a single application that manages all other applications. This is useful for managing multiple applications in a single repository. This is shown in the directory /demos/app-of-apps in this project.


