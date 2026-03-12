terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    proxmox = {
      // https://github.com/bpg/terraform-provider-proxmox/releases
      source  = "bpg/proxmox"
      version = "0.98.1"
    }
    onepassword = {
      // https://github.com/1Password/terraform-provider-onepassword/releases
      source  = "1Password/onepassword"
      version = "3.3.0"
    }
  }
}

provider "proxmox" {
  insecure = true
  endpoint = data.onepassword_item.proxmox_credentials.url
  password = data.onepassword_item.proxmox_credentials.password
  username = "${data.onepassword_item.proxmox_credentials.username}@pam"
}

provider "onepassword" {
  connect_url   = var.onepassword_url
  connect_token = var.onepassword_token
}
