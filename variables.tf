variable "proxmox_host" {
  description = "The Proxmox host to connect to"
  default     = "proxmox"
}

variable "nic_name" {
  description = "The name of the network interface to use for the VMs"
  default     = "vmbr0"
}

variable "base_mac_address" {
  description = "The base MAC address for the VMs, e.g., 'AA:BB:CC:DD:EE'"
  type        = string
  default     = "AA:BB:CC:DD:EE"
}

variable "base_ip_address" {
  description = "The base class C IP address for the VMs, e.g., '10.0.0'"
  type        = string
  default     = ""
}

variable "base_disk_size" {
  description = "The base disk size for the VMs in GB"
  type        = number
  default     = 50
}

variable "onepassword_account" {
  description = "Your 1Password account email"
  type        = string
  default     = ""
}

variable "onepassword_url" {
  description = "Your 1Password account URL"
  type        = string
  default     = ""
}

variable "onepassword_vault" {
  description = "Your 1Password vault name"
  type        = string
  default     = ""
}

variable "clone_vm_id" {
  description = "The Proxmox template to use for the VMs"
  type        = string
  default     = 9991
}

variable "user" {
  description = "The user to create via cloud-init"
  type        = string
  default     = ""
}

variable "vm_datastore_id" {
  description = "The datastore ID for the VMs"
  type        = string
  default     = "local-lvm"
}

variable "snippets_datastore_id" {
  description = "The datastore ID for the snippets"
  type        = string
  default     = "local"
}

variable "domain" {
  description = "The domain to use for the VMs"
  type        = string
  default     = ""
}

variable "cpu_type" {
  description = "The CPU type to use for the VMs, e.g., 'kvm64', 'host', etc."
  type        = string
  default     = "host"
}

variable "initialization_interface" {
  description = "The initialization interface to use for the VMs"
  type        = string
  default     = "scsi10"
}

variable "bios_type" {
  description = "The BIOS type to use for the VMs, e.g., 'ovmf', 'seabios'"
  type        = string
  default     = "ovmf"
}

variable "machine_type" {
  description = "The machine type to use for the VMs, e.g., 'q35', 'pc-i440fx-2.9'"
  type        = string
  default     = "q35"
}