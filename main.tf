terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Configure the Docker Provider
provider "docker" {}

# Pull the nginx image
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Create a container
resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "terraform-nginx-container"
  
  ports {
    internal = 80
    external = 8080
  }

  # Ensure container restarts if it stops
  restart = "unless-stopped"
}

# Output the container information
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx_container.id
}

output "container_name" {
  description = "Name of the Docker container"
  value       = docker_container.nginx_container.name
}

output "access_url" {
  description = "URL to access the application"
  value       = "http://localhost:8080"
}
