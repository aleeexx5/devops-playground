module "nginx" {
  source = "../modules/k8s-app"
  app_name = "nginx"
  image = "nginx:latest"
  replicas = 2
  port = 30080
}

module "postgres" {
  source = "../modules/k8s-app"
  app_name = "postgres"
  image = "postgres:latest"
  replicas = 1
  port = 30081
  env_vars = {
    POSTGRES_USER = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB = "mydb"
  }
}