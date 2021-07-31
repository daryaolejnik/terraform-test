resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = google_compute_instance.vm_instance.*.self_link


  named_port {
    name = "http"
    port = "8080"
  }

  named_port {
    name = "https"
    port = "8443"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance" "vm_instance" {
  count = 2
  name         = element(var.resource_instance_name, count.index)
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "centos-7-v20210721"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}