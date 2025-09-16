variable "proxmox_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.14.100:8006/api2/json"
}

variable "proxmox_user" {
  description = "Proxmox username"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "ssh_public_key" {
  description = "SSH public key file path"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
