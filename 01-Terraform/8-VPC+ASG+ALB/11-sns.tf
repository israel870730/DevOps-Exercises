# Aqui estamos creado el topic SNS
resource "aws_sns_topic" "topic_sns_ssm" {
  name = "topic-sns-ssm"
  display_name = "Test From SNS"
}

# output "sns_topic_arn" {
#   value = aws_sns_topic.topic-sns-ssm.arn
# }

# Aqui le pasamos el correo que va a estar suscrito al topic SNS
resource "aws_sns_topic_subscription" "user_updates_mail_target" {
  topic_arn = aws_sns_topic.topic_sns_ssm.arn
  protocol  = "email"
  #endpoint  = "tu-email@gmail.com"
  endpoint  = "israelg1@verifone.com" #Borrar
}