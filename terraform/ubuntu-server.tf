terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "testvm" {
  name = "test-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_instance" "testvm" {
  name = "test-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
  }

  network_interface {
    subnet_id = "e9bo5km0fltfn2c5frk0"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
  allow_stopping_for_update = true
}