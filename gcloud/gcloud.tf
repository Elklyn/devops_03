provider "google" {
  credentials = file("crashcourse-1de804768632.json")
  project     = "crashcourse-293721"
  region  = "us-east1"
  zone    = "us-east1-b"
  user_project_override = true
}



resource "google_compute_instance" "test_instans" {
  name = "terraform${count.index}"
  count = 2
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20201014"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  provisioner "remote-exec" {
    inline = [
          "echo ${self.network_interface.0.access_config.0.nat_ip} >> ~/IP-address.txt"
      ]

    connection {
          type = "ssh"
          user = "elklyn"
          private_key = file("~/.ssh/id_rsa")
          host = self.network_interface.0.access_config.0.nat_ip
      }
  }
}

resource "google_compute_firewall" "default" {
  name    = "terraformfirewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80", "9090", "22"]
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-vpc-41"
  auto_create_subnetworks = "true"
}

output "ip" {
  value = google_compute_instance.test_instans.*.network_interface.0.access_config.0.nat_ip
}