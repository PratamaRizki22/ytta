resource "google_compute_instance" "terraform" {
  project      = "qwiklabs-gcp-03-13fb605c9648"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
