resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  for_each     = { for s in local.servers_flat : format("%s", s.name) => s }
  content_type = "snippets"
  datastore_id = var.snippets_datastore_id
  node_name    = var.proxmox_host
  source_raw {
    data = <<-EOF
    #cloud-config
    preserve_hostname: false
    create_hostname_file: true
    prefer_fqdn_over_hostname: false
    hostname: ${each.key}
    fqdn: ${each.key}.${var.domain}
    users:
      # - default
      - name: ${var.user}
        gecos: ${var.user}
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${data.onepassword_item.ssh_key.public_key}
        sudo: ALL=(ALL) NOPASSWD:ALL
    # packages:
    #   - qemu-guest-agent
    manage_etc_hosts: localhost
    EOF

    file_name = "user-data-${each.key}.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "servers" {
  for_each  = { for s in local.servers_flat : format("%s", s.name) => s }
  name      = each.key
  node_name = var.proxmox_host
  initialization {
    interface         = var.initialization_interface
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[each.key].id
  }
  stop_on_destroy = true
  vm_id           = each.value.vmid
  bios            = var.bios_type
  machine         = var.machine_type
  agent {
    enabled = true
    trim    = true
  }
  clone {
    vm_id = var.clone_vm_id
  }
  operating_system {
    type = each.value.operating_system
  }
  memory {
    dedicated = each.value.memory
  }
  scsi_hardware = "virtio-scsi-single"
  cpu {
    cores   = each.value.cores
    sockets = 1
    type    = var.cpu_type
  }
  network_device {
    model       = "virtio"
    bridge      = var.nic_name
    mac_address = each.value.mac_address
  }
  disk {
    interface    = "scsi0"
    datastore_id = var.vm_datastore_id
    size         = var.base_disk_size
    discard      = "on"
    ssd          = true
    iothread     = true
    replicate    = false
    cache        = "unsafe"
  }
  dynamic "usb" {
    for_each = each.value.usb != null ? [each.value.usb] : []
    content {
      host = each.value.usb
    }
  }
  dynamic "disk" {
    for_each = each.value.disk != [] ? each.value.disk : []
    content {
      interface    = contains(keys(disk.value), "interface") ? disk.value.interface : "scsi0"
      size         = contains(keys(disk.value), "size") ? disk.value.size : var.base_disk_size
      datastore_id = contains(keys(disk.value), "vm_datastore_id") ? disk.value.datastore_id : var.vm_datastore_id
      discard      = contains(keys(disk.value), "discard") ? disk.value.discard : "ignore"
      ssd          = contains(keys(disk.value), "ssd") ? (disk.value.ssd ? true : false) : false
      iothread     = contains(keys(disk.value), "iothread") ? (disk.value.iothread ? true : false) : false
      replicate    = false
      cache        = "unsafe"
    }
  }
}