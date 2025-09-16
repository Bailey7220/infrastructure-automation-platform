terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "web_server" {
  name        = "web-server-001"
  target_node = var.proxmox_node
  clone       = "ubuntu-cloud-template"
  
  cores  = 2
  memory = 2048
  
  disk {
    slot    = 0
    size    = "20G"
    type    = "scsi"
    storage = "local-lvm"
  }
  
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  os_type    = "cloud-init"
  ciuser     = "vagrant"
  cipassword = "vagrant"
  sshkeys    = file(var.ssh_public_key)
  
  ipconfig0 = "ip=dhcp"
}

resource "proxmox_vm_qemu" "monitoring_server" {
  name        = "monitoring-001"
  target_node = var.proxmox_node
  clone       = "ubuntu-cloud-template"
  
  cores  = 2
  memory = 4096
  
  disk {
    slot    = 0
    size    = "30G"
    type    = "scsi"
    storage = "local-lvm"
  }
  
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  os_type    = "cloud-init"
  ciuser     = "vagrant"
  cipassword = "vagrant"
  sshkeys    = file(var.ssh_public_key)
  
  ipconfig0 = "ip=dhcp"
}

resource "proxmox_vm_qemu" "vault_server" {
  name        = "vault-001"
  target_node = var.proxmox_node
  clone       = "ubuntu-cloud-template"
  cores       = 2
  memory      = 2048

  disk {
    slot    = 0
    size    = "10G"
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type    = "cloud-init"
  ciuser     = "vagrant"
  cipassword = "vagrant"
  sshkeys    = file(var.ssh_public_key)
  ipconfig0  = "ip=dhcp"
}
