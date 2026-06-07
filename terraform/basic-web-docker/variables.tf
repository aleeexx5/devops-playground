variable "container_name" {
  type    = string
  description = "Name of the Docker container"
  default = "web-server"
}
variable "external_port" {
  type    = number
  description = "External port for the Docker container"
  default = 8080
}
variable "internal_port" {
  type    = number
  description = "Internal port for the Docker container"
  default = 80
}
variable "container_image" {
  type    = string
  description = "Docker image to use for the container"
  default = "nginx:latest"
}