output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = module.virtual_machine_loadbalancer.load_balancer_public_ip
}

output "web_url" {
  description = "HTTP URL served by the Linux VM through the load balancer"
  value       = module.virtual_machine_loadbalancer.web_url
}

output "ssh_command" {
  description = "SSH command for connecting through the load balancer"
  value       = module.virtual_machine_loadbalancer.ssh_command
}

output "vm_private_ip" {
  description = "Private IP address of the Linux VM"
  value       = module.virtual_machine_loadbalancer.vm_private_ip
}
