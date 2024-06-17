resource "aws_iam_role" "cloud_custodian_role" {
  name = "cloud-custodian-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole_attach" {
  role       = aws_iam_role.cloud_custodian_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "cloud_custodian_policy" {
  name = "cloud-custodian-policy"
  role = "${aws_iam_role.cloud_custodian_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:DescribeTags",
          "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
