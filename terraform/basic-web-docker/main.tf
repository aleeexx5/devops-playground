resource "docker_image" "nginx" {
  name         = var.container_image
  keep_locally = true
}

resource "docker_container" "web" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}