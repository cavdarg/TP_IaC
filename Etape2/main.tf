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

# Créer l'image MySQL
resource "docker_image" "mysql_image" {
  name = "mysql:latest"
}


# Créer le conteneur MySQL (DATA)
resource "docker_container" "mysql_container" {
  name  = "data"
  image = docker_image.mysql_image.name

  networks_advanced {
    name = docker_network.my_network.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_DATABASE=mydb",  # Assurez-vous que le nom de la base de données est correct
    "MYSQL_USER=gurcu",     # Utilisateur de la base de données
    "MYSQL_PASSWORD=cavdar58"  # Mot de passe de l'utilisateur
  ]

  volumes {
    container_path = "/var/lib/mysql"
    host_path      = "C:/Users/gucav/OneDrive/Bureau/EFREI/Mastere_DE2/DevOps_MlOps/Cours3/IaC/Etape1/mysql_data"  # Chemin pour stocker les données
  }
}

# Créer le conteneur PHP-FPM (SCRIPT)
resource "docker_container" "php_fpm_container" {
  name  = "script"
  image = docker_image.php_fpm_image.name

  networks_advanced {
    name = docker_network.my_network.name
  }

  volumes {
    container_path = "/app"
    host_path      = "C:/Users/gucav/OneDrive/Bureau/EFREI/Mastere_DE2/DevOps_MlOps/Cours3/IaC/Etape1/"  # Montre le répertoire contenant test_bdd.php
  }

  depends_on = [docker_container.mysql_container]
}

# Créer le conteneur NGINX (HTTP)
resource "docker_container" "nginx_container" {
  name  = "http"
  image = docker_image.nginx_image.name

  networks_advanced {
    name = docker_network.my_network.name
  }

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    container_path = "/app"
    host_path      = "C:/Users/gucav/OneDrive/Bureau/EFREI/Mastere_DE2/DevOps_MlOps/Cours3/IaC/Etape1/"  # Montre le répertoire contenant test_bdd.php
  }

  command = [
    "nginx", "-g", "daemon off;"
  ]

  depends_on = [docker_container.php_fpm_container]
}
