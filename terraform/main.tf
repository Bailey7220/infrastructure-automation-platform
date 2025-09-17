terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.57.1"
    }
  }
}

provider "proxmox" {

}

resource "proxmox_virtual_environment_vm" "web_server" {
  name        = "web-server-001"
  description = "Managed by Terraform"
  tags        = ["terraform", "web", "ubuntu"]
  node_name   = var.proxmox_node

  clone {
    vm_id = 300
    full  = true
  }

  cpu {
    cores  = 2
    type   = "host"
  }

  memory {
    dedicated = 2048
  }
 
  disk {
    datastore_id = "sas-disk1"
    interface    = "scsi0"
    size         = 20
    file_format  = "raw"
    cache        = "writeback"
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_data_file_id        = "local:snippets/cloud-init.yaml"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "vagrant"
      password = "vagrant"
      keys     = [file(var.ssh_public_key)]
    }
} 
  agent {
    enabled = true
  }
}


resource "proxmox_virtual_environment_vm" "monitoring_server" {
  name        = "monitoring-001"
  description = "Monitoring server managed by Terraform"
  tags        = ["terraform", "monitoring", "ubuntu"]
  node_name   = var.proxmox_node

  clone {
    vm_id = 300  
    full  = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  disk {
    datastore_id = "sas-disk1"
    interface    = "scsi0"
    size         = 30
    file_format  = "raw"
    cache        = "writeback"
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_data_file_id        = "local:snippets/cloud-init.yaml"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "vagrant"
      password = "vagrant"
      keys     = [file(var.ssh_public_key)]
    }
  }

  agent {
    enabled = true
  }
}

resource "proxmox_virtual_environment_vm" "vault_server" {
  name        = "vault-001"
  description = "HashiCorp Vault server managed by Terraform"
  tags        = ["terraform", "vault", "ubuntu"]
  node_name   = var.proxmox_node

  clone {
    vm_id = 300  
    full  = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "sas-disk1"
    interface    = "scsi0"
    size         = 10
    file_format  = "raw"
    cache        = "writeback"
    iothread     = true
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_data_file_id        = "local:snippets/cloud-init.yaml"


    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "vagrant"
      password = "vagrant"
      keys     = [file(var.ssh_public_key)]
    }
  }

  agent {
    enabled = true
  }
}
