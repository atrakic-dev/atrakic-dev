variable "enabled" {
  description = "Set to false to prevent from creating any resources"
  default     = "false"
}

variable "this_version" {
  description = "Runtime placeholder"
  default     = "default"
}

locals {
  enabled  = var.enabled == "true" ? true : false
  name     = "flask-app"
  ssh_keys = [25624561]
  image    = "ubuntu-18-04-x64"
  region   = "ams3"
  size     = "s-1vcpu-1gb"
  this_version = var.this_version
}

provider "digitalocean" {}

resource "digitalocean_droplet" "docker-compose-server" {
  count     = local.enabled == true ? 1 : 0
  image     = local.image
  region    = local.region
  size      = local.size
  ipv6      = true
  name      = format("%s-%d", local.name, count.index)
  ssh_keys  = local.ssh_keys
  user_data = file("${path.module}/userdata.sh")
  tags      = ["terraform"]
}

output "this_version" {
  value = local.this_version
}
