output "dns_ALB" {
    description = "DNS pública del load balancer"
    value = "http://${aws_lb.demo_lb.dns_name}:${var.puerto_lb}"
}

output "dns_publica_servidor_1" {
  description = "DNS pública del servidor"
  value       = "http://${aws_instance.demo_1.public_dns}:${var.puerto_servidor}"
}

output "dns_publica_servidor_2" {
  description = "DNS pública del servidor"
  value       = "http://${aws_instance.demo_2.public_dns}:${var.puerto_servidor}"
}

output "ip_publica_servidor_1" {
  description = "IP pública IPV4 del servidor"
  value       = "${aws_instance.demo_1.public_ip}"
}

output "ip_publica_servidor_2" {
  description = "IP pública IPV4 del servidor"
  value       = "${aws_instance.demo_2.public_ip}"
}