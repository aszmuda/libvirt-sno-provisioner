# variables that can be overriden
variable "domain" { default = "mydomain.com" }
variable "dns" { default = "192.168.1.17" }
variable "network_cidr" {
  type = list
  default = ["192.168.1.0/24"]
}
variable "cluster_name" { default = "sno" }
variable "libvirt_pool_path" { default = "/var/lib/libvirt/images" }

# instance the provider
provider "libvirt" {
  uri = "qemu:///session"
}

# A pool for all cluster volumes
resource "libvirt_pool" "cluster" {
  name = var.cluster_name
  type = "dir"
  path = "${var.libvirt_pool_path}/${var.cluster_name}"
}

terraform {
 required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

