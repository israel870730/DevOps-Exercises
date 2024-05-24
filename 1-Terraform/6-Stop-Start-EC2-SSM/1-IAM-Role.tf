resource "aws_iam_role" "Start-Stop-EC2-SSM" {
  name = "Start-Stop-EC2-SSM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ssm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_AmazonSSMAutomationRole" {
  name       = "attach-AmazonSSMAutomationRole"
  roles      = [aws_iam_role.Start-Stop-EC2-SSM.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}

resource "aws_iam_policy_attachment" "attach_AmazonSSMMaintenanceWindowRole" {
  name       = "attach-AmazonSSMMaintenanceWindowRole"
  roles      = [aws_iam_role.Start-Stop-EC2-SSM.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_policy_attachment" "attach_AmazonSNSFullAccess" {
  name       = "attach-AmazonSNSFullAccess"
  roles      = [aws_iam_role.Start-Stop-EC2-SSM.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}