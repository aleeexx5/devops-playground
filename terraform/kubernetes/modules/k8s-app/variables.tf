variable "app_name" {
  type = string
  description = "The name of the application to deploy."
}

variable "image" {
  type = string
  description = "The container image to use for the application."
}

variable "port" {
  type = number
  description = "The port on which the application will listen."
}

variable "replicas" {
  type = number
  description = "The number of replicas to deploy."
  default = 1
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables for the container"
  default     = {}
}