# Aqui estamos creado el topic SNS
resource "aws_sns_topic" "topic_sns" {
  name = "topic-sns"
  display_name = "Test From SNS"
}

# Aqui le pasamos el correo que va a estar suscrito al topic SNS
resource "aws_sns_topic_subscription" "user_updates_mail_target" {
  topic_arn = aws_sns_topic.topic_sns.arn
  protocol  = "email"
  endpoint  = "tu-email@gmail.com" # Update
}