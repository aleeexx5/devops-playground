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
│       └── basic-web/          # nginx Deployment + Service on Minikube
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
minikube service <name> --url  # get tunnel URL for a service
```

## Notes

- `*.tfstate` files are ignored — never commit them to Git
- `.terraform/` directories are ignored — regenerated with `terraform init`
- Sensitive variables (e.g. `postgres_password`) use `TF_VAR_` environment variables
- Docker Desktop on Linux requires the `desktop-linux` context
