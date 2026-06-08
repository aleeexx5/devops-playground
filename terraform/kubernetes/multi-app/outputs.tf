output "nginx_url" {
  value = module.nginx.url_command
}

output "postgres_url" {
  value = module.postgres.url_command
}