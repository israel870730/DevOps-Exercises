output "dns_ALB" {
    description = "DNS pública del load balancer"
    value = "http://${aws_lb.demo_lb.dns_name}:${var.puerto_lb}"
}
