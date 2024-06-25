output "dns_ALB" {
    description = "DNS pública del load balancer"
    value = "http://${aws_lb.demo_lb.dns_name}:${var.puerto_lb}"
}

output "dns_publica_servidor" {
  description = "DNS pública de los servidores"
  value       = [ for instance in aws_instance.demo :
  "http://${instance.public_dns}:${var.puerto_servidor}"
  ]
}

output "ip_publica_servidor" {
  description = "IP pública IPV4 de los servidores"
  value       = [for instance in aws_instance.demo : "${instance.public_ip}"]
}
