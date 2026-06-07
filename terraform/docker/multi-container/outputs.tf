output "nginx_url" {
  description = "URL to access the Nginx server"
  value = "http://localhost:${var.nginx_port_external}"
}

output "postgres_url" {
  description = "Connection string for the PostgreSQL database"
  value = "postgresql://${var.postgres_user}:<password>@localhost:${var.postgres_port}/${var.postgres_db}"
}
