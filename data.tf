data "onepassword_item" "proxmox_credentials" {
  vault = var.onepassword_vault
  title = "proxmox_credentials"
}

data "onepassword_item" "ssh_key" {
  vault = var.onepassword_vault
  title = "ssh_key"
}