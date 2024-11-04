terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.14"
    }
  }

  required_version = ">= 0.12"
}

provider "docker" {
  host = "tcp://localhost:2375/"
}

# Créer un réseau Docker
resource "docker_network" "my_network" {
  name = "my_network"
}

# Créer l'image NGINX
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}

# Créer l'image PHP-FPM
resource "docker_image" "php_fpm_image" {
  name = "php:8.0-fpm"
}

# Créer le conteneur PHP-FPM
resource "docker_container" "php_fpm_container" {
  name  = "script"
  image = docker_image.php_fpm_image.name  # Utiliser .name au lieu de .latest

  networks_advanced {
    name = docker_network.my_network.name
  }

  volumes {
    container_path = "/app"
    host_path      = "C:/Users/gucav/OneDrive/Bureau/EFREI/Mastere_DE2/DevOps_MlOps/Cours3/IaC/Etape1/"  # Utiliser le chemin absolu
  }

  depends_on = [docker_image.php_fpm_image]
}

# Créer le conteneur NGINX
resource "docker_container" "nginx_container" {
  name  = "http"
  image = docker_image.nginx_image.name  # Utiliser .name au lieu de .latest

  networks_advanced {
    name = docker_network.my_network.name
  }

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    container_path = "/app"
    host_path      = "C:/Users/gucav/OneDrive/Bureau/EFREI/Mastere_DE2/DevOps_MlOps/Cours3/IaC/Etape1/"  # Utiliser le chemin absolu
  }

  depends_on = [docker_container.php_fpm_container]  
}
