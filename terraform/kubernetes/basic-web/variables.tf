variable "app_name" {
  type    = string
  description = "The name of the application"
  default = "nginx"
}

variable "image" {
  type    = string
  description = "The image for the application"
  default = "nginx:latest"
}

variable "replicas" {
  type    = number
  description = "The number of replicas for the deployment"
  default = 2
}

variable "port" {
  type    = number
  description = "The port for the application"
  default = 30080
}