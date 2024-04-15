resource "aws_iam_role" "poc_role" {
  name = "poc_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.poc_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach_amazon_ssm_full_access-poc_role" {
  name       = "attach-amazon-ssm-full-access-poc_role"
  roles      = [aws_iam_role.poc_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_policy_attachment" "attach_amazon_ec2_role_for_ssm-poc_role" {
  name       = "attach-amazon-ec2-role-for-ssm-poc_role"
  roles      = [aws_iam_role.poc_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}


resource "aws_iam_instance_profile" "poc_profile" {
  name = "poc_profile"
  role = "${aws_iam_role.poc_role.name}"
}
