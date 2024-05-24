resource "aws_sns_topic" "topic-sns-ssm" {
  name = "topic-sns-ssm"
  display_name = "Test From SSM"
}

# output "sns_topic_arn" {
#   value = aws_sns_topic.topic-sns-ssm.arn
# }

resource "aws_sns_topic_subscription" "user_updates_mail_target" {
  topic_arn = aws_sns_topic.topic-sns-ssm.arn
  protocol  = "email"
  endpoint  = "israel.garcia@verifone.com"
}