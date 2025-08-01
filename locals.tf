locals {
  servers_flat = flatten([
    for key, value in local.servers : [
      for n in range(value.count) : {
        index            = n + 1
        name             = contains(keys(value), "name_override") ? value.name_override : "${key}${n + 1}"
        disk_size        = contains(keys(value), "disk_size") ? value.disk_size : var.base_disk_size
        operating_system = contains(keys(value), "os") ? value.os : "l26"
        cores            = value.cores
        memory           = value.memory
        ip               = "${var.base_ip_address}.${tonumber(value.ip_start) + n}"
        vmid             = value.ip_start + n
        mac_address      = "${var.base_mac_address}:${format("%02d", tonumber(substr(value.ip_start, -2, -1)) + n)}"
        disk             = contains(keys(value), "disk") ? value.disk : []
        usb              = contains(keys(value), "usb") ? value.usb : null
      }
    ]
  ])
}
