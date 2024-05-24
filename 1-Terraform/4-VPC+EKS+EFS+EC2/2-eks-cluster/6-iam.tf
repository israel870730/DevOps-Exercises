########################################
# Rol para el iam_instance_profile
########################################
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

  tags = {
      tag-key = "demo"
  }
}

########################################
# Politicas adjutadas para el demo_role 
########################################
resource "aws_iam_policy_attachment" "attach_amazon_ssm_full_access-demo_role" {
  name       = "attach-amazon-ssm-full-access-demo_role"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_policy_attachment" "attach_amazon_ec2_role_for_ssm-demo_role" {
  name       = "attach-amazon-ec2-role-for-ssm-demo_role"
  roles      = [aws_iam_role.demo_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

########################################
# iam_instance_profile 
########################################
resource "aws_iam_instance_profile" "demo_profile" {
  name = "demo_profile"
  role = "${aws_iam_role.demo_role.name}"
}
