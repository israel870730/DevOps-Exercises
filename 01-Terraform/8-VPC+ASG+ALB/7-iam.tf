resource "aws_iam_role" "demo_role" {
  name = "demo_role"

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
}

resource "aws_iam_policy_attachment" "attach_amazon_full_access-demo_role" {
  name       = "attach-amazon-full-access-demo_role"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_policy_attachment" "attach_amazon_ec2_role_for-demo_role" {
  name       = "attach-amazon-ec2-role-for-demo_role"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "demo_profile" {
  name = "demo_profile"
  role = "${aws_iam_role.demo_role.name}"
}
