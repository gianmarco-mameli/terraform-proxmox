terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    proxmox = {
      // https://github.com/bpg/terraform-provider-proxmox/releases
      source  = "bpg/proxmox"
      version = "0.95.0"
    }
    onepassword = {
      // https://github.com/1Password/terraform-provider-onepassword/releases
      source  = "1Password/onepassword"
      version = "2.2.1"
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
