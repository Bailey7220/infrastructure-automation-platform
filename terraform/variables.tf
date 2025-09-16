variable "proxmox_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.14.4:8006/api2/json"
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

variable "proxmox_token_id" {
  description = "Proxmox API token ID in format user@realm!tokenID"
  type        = string
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}
