output "web_server_ip" {
  description = "IP address of the web server"
  value       = proxmox_virtual_environment_vm.web_server.ipv4_addresses[1][0]
}

output "monitoring_server_ip" {
  description = "IP address of the monitoring server"
  value       = proxmox_virtual_environment_vm.monitoring_server.ipv4_addresses[1][0]
}

output "vault_server_ip" {
  description = "IP address of the vault server"
  value       = proxmox_virtual_environment_vm.vault_server.ipv4_addresses[1][0]
}

output "web_server_id" {
  description = "VM ID of the web server"
  value       = proxmox_virtual_environment_vm.web_server.vm_id
}

