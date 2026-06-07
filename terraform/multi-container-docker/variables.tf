variable "postgres_password" {
  type      = string
  description = "Password for the PostgreSQL database"
  sensitive = true
}

variable "postgres_user" {
  type      = string
  description = "Username for the PostgreSQL database"
  default = "postgres"
}

variable "postgres_db" {
  type      = string
  description = "Name of the PostgreSQL database"
  default = "mydb"
}

variable "nginx_port_external" {
  type      = number
  description = "External port for the Nginx server"
  default = 8080
}

variable "postgres_port" {
  type      = number
  description = "Port for the PostgreSQL database"
  default = 5432
}

variable "container_image" {
  type        = string
  description = "Docker image to use for the Nginx container"
  default     = "nginx:latest"
}