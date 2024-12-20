##################
#Creamos el ALB ##
##################
resource "aws_lb" "demo_lb" {
  load_balancer_type        = "application"
  name                      = "demo-alb"
  security_groups           = [aws_security_group.alb_sg.id]
  subnets                   = module.vpc.public_subnets
}

#Creamos el Targuet Group
resource "aws_lb_target_group" "demo" {
  name     = "demo-alb-target-group"
  port     = 80
  vpc_id   = module.vpc.vpc_id
  protocol = "HTTP"
  
  health_check {
    enabled   = true
    matcher  = "200"
    path     = "/" 
    port     = var.puerto_servidor
    protocol = "HTTP"
  }
}

#Adjuntamos las instancias EC2 al targuet group que pertenece al ALB
resource "aws_lb_target_group_attachment" "demo_1" {
  count             = var.instance_count
  target_group_arn  = aws_lb_target_group.demo.arn
  target_id         = aws_instance.demo[count.index].id // Como estamos usando un count para las intancias usamos count.index
  port              = var.puerto_servidor
}

#Creamos el listener para en el ALB y le adjuntamos el TG
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.demo_lb.arn
  port              = var.puerto_lb
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.demo.arn
    type             = "forward"
  } 
}