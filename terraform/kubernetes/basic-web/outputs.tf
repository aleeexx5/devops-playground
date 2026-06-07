output "url_command" {
  description = "Command to get the service URL"
  value       = "minikube service ${var.app_name}-service --url"
}