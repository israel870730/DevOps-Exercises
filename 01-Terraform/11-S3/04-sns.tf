# Aqui estamos creado el topic SNS
resource "aws_sns_topic" "topic_sns_s3" {
  name = "topic-sns-s3"
  display_name = "Test From SNS"
}

# Aqui le pasamos el correo que va a estar suscrito al topic SNS
resource "aws_sns_topic_subscription" "user_updates_mail_target" {
  topic_arn = aws_sns_topic.topic_sns_s3.arn
  protocol  = "email"
  endpoint  = "Israel.Garcia@VERIFONE.com"
}

resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn    = aws_sns_topic.topic_sns_s3.arn
  policy = data.aws_iam_policy_document.topic_policy.json
}
