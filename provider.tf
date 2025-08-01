terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.80.0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = "2.1.2"
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
  url     = var.onepassword_url
  account = var.onepassword_account
}
