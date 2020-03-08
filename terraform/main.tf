provider "google" {
  project = "ai-roadmap-new"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "default" {
  name         = "terraform-vm"
  machine_type = "f1-micro"
  zone         = "us-central1-c"
  
  labels = {
    team = "devops"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
 
  metadata = {
    ssh-keys = "devops:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    network = "default"

    access_config {
     // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "terraform-vm-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }
}

resource "google_storage_bucket" "bucket" {
  name     = "terraform-vm-bucket"
  location = "US" 
}
