output "web_server_ip" {
  description = "IP address of the web server"
  value       = proxmox_vm_qemu.web_server.default_ipv4_address
}

output "monitoring_server_ip" {
  description = "IP address of the monitoring server"
  value       = proxmox_vm_qemu.monitoring_server.default_ipv4_address
}

output "web_server_id" {
  description = "VM ID of the web server"
  value       = proxmox_vm_qemu.web_server.vmid
}
