# devops-playground

Personal learning repo for DevOps tools and concepts. Each project is self-contained and can be run independently.

## Structure

```
devops-playground/
├── terraform/
│   ├── aws/
│   │   └── basic-web/          # EC2 + VPC + Security Group with LocalStack
│   ├── docker/
│   │   ├── basic-web/          # nginx container with Docker provider
│   │   └── multi-container/    # nginx + postgres with Docker networking
│   └── kubernetes/
│       ├── basic-web/          # nginx Deployment + Service on Minikube
│       ├── modules/
│       │   └── k8s-app/        # reusable module: Deployment + Service
│       └── multi-app/          # nginx + postgres using the k8s-app module
└── helm/
    └── charts/
        ├── k8s-app/                # custom Helm chart with NodePort and env vars
        └── cronjob/                # custom Helm chart for Kubernetes CronJobs
└── .github/
    └── workflows/
        └── helm-lint.yaml          # CI pipeline: lint and validate Helm charts
```

## Projects

### terraform/aws/basic-web

Deploys a basic web server on AWS using Terraform. Simulated locally with LocalStack (no AWS account required).

**Resources:** VPC, Subnet, Security Group, EC2 instance (nginx via user_data)

**Requirements:**
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [LocalStack](https://docs.localstack.cloud/getting-started/installation/)

```bash
LOCALSTACK_ACKNOWLEDGE_ACCOUNT_REQUIREMENT=1 localstack start
cd terraform/aws/basic-web
terraform init
terraform apply
```

---

### terraform/docker/basic-web

Deploys an nginx container using the Terraform Docker provider. Fully functional — the web is accessible in the browser.

**Resources:** docker_image, docker_container

**Requirements:**
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

```bash
cd terraform/docker/basic-web
terraform init
terraform apply
# open http://localhost:8080
```

---

### terraform/docker/multi-container

Deploys nginx and postgres connected through a Docker network. Includes a persistent volume for postgres data.

**Resources:** docker_network, docker_volume, docker_image (x2), docker_container (x2)

**Requirements:**
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

```bash
export TF_VAR_postgres_password="yourpassword"
cd terraform/docker/multi-container
terraform init
terraform apply
# nginx  → http://localhost:8080
# postgres → localhost:5432
```

To connect to postgres:
```bash
docker exec -it postgres_db psql -U postgres -d mydb
```

---

### terraform/kubernetes/basic-web

Deploys nginx on a local Kubernetes cluster using Minikube and the Terraform Kubernetes provider.

**Resources:** kubernetes_deployment (2 replicas), kubernetes_service (NodePort)

**Requirements:**
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

```bash
minikube start --driver=docker
cd terraform/kubernetes/basic-web
terraform init
terraform apply
minikube service nginx-service --url
```

---

### terraform/kubernetes/modules/k8s-app

Reusable Terraform module that creates a Kubernetes Deployment and NodePort Service for any app. Accepts env vars for configuration.

**Resources:** kubernetes_deployment, kubernetes_service

---

### terraform/kubernetes/multi-app

Deploys nginx and postgres on Minikube using the reusable `k8s-app` module. Demonstrates how modules avoid code repetition.

**Resources:** 2x kubernetes_deployment, 2x kubernetes_service (via module)

**Requirements:**
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

```bash
minikube start --driver=docker
cd terraform/kubernetes/multi-app
terraform init
terraform apply
minikube service nginx-service --url
minikube service postgres-service --url
```

To connect to postgres from inside the cluster:
```bash
kubectl exec -it $(kubectl get pod -l app=postgres -o jsonpath='{.items[0].metadata.name}') -- psql -U postgres -d mydb
```

---

## Helm

### helm/charts/k8s-app

Custom Helm chart that deploys any app on Kubernetes with NodePort service and optional environment variables. Built from `helm create` and customized with templating.

**Requirements:**
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)

```bash
minikube start --driver=docker
cd helm/charts
helm lint k8s-app
helm template mi-app ./k8s-app
helm install mi-app ./k8s-app
minikube service mi-app-k8s-app --url
```

To pass custom values:
```bash
helm install mi-app ./k8s-app --set replicaCount=3
helm install mi-app ./k8s-app -f my-values.yaml
```

Upgrade and rollback:
```bash
helm upgrade mi-app ./k8s-app --set replicaCount=3
helm rollback mi-app 1
helm history mi-app
helm uninstall mi-app
```

---

### helm/charts/cronjob

Custom Helm chart for Kubernetes CronJobs. Runs a curl command on a schedule with configurable image, command, and environment variables.

**Requirements:**
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)

```bash
minikube start --driver=docker
cd helm/charts
helm lint cronjob
helm template my-cronjob ./cronjob
helm install my-cronjob ./cronjob
kubectl get cronjobs
kubectl get jobs
```

To customize:
```bash
helm install my-cronjob ./cronjob \
  --set schedule="0 * * * *" \
  --set image.repository=curlimages/curl \
  --set "command={curl,https://httpbin.org/get}"
```

---

## CI/CD

### .github/workflows/helm-lint.yaml

GitHub Actions workflow that validates Helm charts on every push to `main` that modifies files under `helm/charts/`. Runs `helm lint` and `helm template` on both charts.

**Triggers:** push to `main` with changes in `helm/charts/**`

**Steps:**
1. Checkout code
2. Lint and template `k8s-app` chart
3. Lint and template `cronjob` chart

---

## Key concepts covered

- **Providers** — AWS, Docker, Kubernetes
- **Resources** — the building blocks of infrastructure
- **Variables** — parameterize configuration
- **Locals** — internal computed values
- **Outputs** — expose values after apply
- **State** — how Terraform tracks what exists
- **depends_on** — explicit resource dependencies
- **Docker networking** — connect containers via a shared network
- **Kubernetes Deployments** — manage pods with replicas
- **Kubernetes Services** — expose deployments (NodePort)
- **Modules** — reusable infrastructure components
- **dynamic blocks** — generate repeated blocks from a map or list
- **map type** — key-value collection for env vars and tags
- **Helm charts** — packaged Kubernetes applications
- **Helm values** — parameterize charts via values.yaml
- **Helm templates** — Go templating for Kubernetes manifests
- **Helm releases** — versioned deployments with rollback support
- **Kubernetes CronJobs** — scheduled tasks that create pods on a cron schedule

## Useful commands

```bash
terraform init       # download providers and modules
terraform plan       # preview changes
terraform apply      # apply changes
terraform destroy    # destroy infrastructure
terraform output     # show outputs
terraform fmt        # format code
terraform validate   # validate syntax

kubectl get pods     # list kubernetes pods
kubectl get services # list kubernetes services
kubectl get all      # list all kubernetes resources
kubectl get cronjobs # list kubernetes cronjobs
kubectl get jobs     # list kubernetes jobs
minikube service <name> --url  # get tunnel URL for a service

helm install <name> <chart>    # install a chart
helm upgrade <name> <chart>    # upgrade a release
helm rollback <name> <rev>     # rollback to a revision
helm uninstall <name>          # uninstall a release
helm history <name>            # show release history
helm lint <chart>              # validate a chart
helm template <name> <chart>   # preview generated manifests
helm repo add <name> <url>     # add a chart repository
helm search repo <query>       # search for charts
```

## Notes

- `*.tfstate` files are ignored — never commit them to Git
- `.terraform/` directories are ignored — regenerated with `terraform init`
- Sensitive variables (e.g. `postgres_password`) use `TF_VAR_` environment variables
- Docker Desktop on Linux requires the `desktop-linux` context