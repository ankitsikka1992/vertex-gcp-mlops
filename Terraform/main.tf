terraform {
  backend "gcs" {
    bucket  = ""
    prefix  = ""
  }
}

# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
  credentials=var.credentials
}


# Variables for project, region, and zone
variable "project_id" {
  description = "The ID of the project in which to create resources."
  default     = "abc"
}

variable "credentials" {
  description = "Creds File"
  default     = "abc.json"
}
variable "region" {
  description = "The region where resources will be created."
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where resources will be created."
  default     = "us-central1-a"
}

# Enable necessary APIs for Vertex AI
resource "google_project_service" "vertex_ai_api" {
  project = var.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"
}

resource "google_project_service" "storage_api" {
  project = var.project_id
  service = "storage.googleapis.com"
}

# Create a Vertex AI Notebook Instance
resource "google_notebooks_instance" "vertex_ai_notebook" {
  project   = var.project_id
  name      = "vertex-ai-notebook"
  location  = var.zone
  machine_type = "n1-standard-4"

  vm_image {
    project = "deeplearning-platform-release"
    image_family = "tf2-latest-cpu"
  }
}

# Output the Notebook instance details
output "vertex_ai_notebook_name" {
  value = google_notebooks_instance.vertex_ai_notebook.name
}

output "vertex_ai_notebook_zone" {
  value = google_notebooks_instance.vertex_ai_notebook.location
}

output "vertex_ai_notebook_id" {
  value = google_notebooks_instance.vertex_ai_notebook.id
}
