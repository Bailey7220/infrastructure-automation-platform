variable "proxmox_node" {
  description = "Existing Proxmox node for the lab VMs."
  type        = string
}

variable "ssh_public_key" {
  description = "Guest SSH public-key path; expanded with pathexpand before reading."
  type        = string
  default     = "~/.ssh/proxmox_lab.pub"
}
