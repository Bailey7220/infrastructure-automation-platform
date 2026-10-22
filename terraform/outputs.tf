# Best-effort guest-agent addresses, not verified primary management addresses.
output "web_server_ip" {
  description = "Guest-agent address; null if unavailable. Verify before use."
  value       = try(proxmox_virtual_environment_vm.web_server.ipv4_addresses[1][0], null)
}

output "monitoring_server_ip" {
  description = "Guest-agent address; null if unavailable. Verify before use."
  value       = try(proxmox_virtual_environment_vm.monitoring_server.ipv4_addresses[1][0], null)
}

output "vault_server_ip" {
  description = "Guest-agent address; null if unavailable. Verify before use."
  value       = try(proxmox_virtual_environment_vm.vault_server.ipv4_addresses[1][0], null)
}

output "web_server_id" {
  value = proxmox_virtual_environment_vm.web_server.vm_id
}

output "monitoring_server_id" {
  value = proxmox_virtual_environment_vm.monitoring_server.vm_id
}

output "vault_server_id" {
  value = proxmox_virtual_environment_vm.vault_server.vm_id
}
