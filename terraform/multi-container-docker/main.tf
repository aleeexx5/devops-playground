resource "docker_network" "app_network" {
  name = "app_network"
  driver = "bridge"  
}

resource "docker_image" "nginx" {
  name         = var.container_image
  keep_locally = true
}

resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = true
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}",
    "PGDATA=/var/lib/postgresql/data/pgdata"
  ]

  ports {
    internal = 5432
    external = var.postgres_port
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [
    docker_network.app_network,
    docker_volume.postgres_data
  ]
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_port_external
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [
    docker_network.app_network
  ]
}
