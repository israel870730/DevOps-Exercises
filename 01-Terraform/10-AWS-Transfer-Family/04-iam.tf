########################################################################
# AWS-Transfer-Family Role for user with access to S3 service
########################################################################
resource "aws_iam_role" "AWSTransferSFTPS3AccessRole" {
  name = "AWSTransferSFTPS3AccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
########################################################################
# AWS-Transfer-Family Policy for user with access to S3 service
# Actualizar el ARN del Bucket
########################################################################
resource "aws_iam_role_policy" "AWSTransferSFTPS3AccessPolicy" {
  name = "AWSTransferSFTPS3AccessPolicy"
  role = "${aws_iam_role.AWSTransferSFTPS3AccessRole.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
          "arn:aws:s3:::poc-us-west-1-sftp",
          "arn:aws:s3:::poc-us-west-1-sftp/*"
      ]
    }
  ]
}
EOF
}
##################
# EC2 Role
##################
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
}
##################
# EC2 Policy
##################
resource "aws_iam_role_policy" "demo_policy" {
  name = "demo_policy"
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
####################################
# Attach policys to EC2 Role
####################################
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
####################################
# Create instance profile to EC2
####################################
resource "aws_iam_instance_profile" "poc_profile" {
  name = "poc_profile"
  role = "${aws_iam_role.poc_role.name}"
}
########################################################################
# AWS-Transfer-Family Role for user with access to S3 service
########################################################################
resource "aws_iam_role" "AWSTransferSFTPEFSAccessRole" {
  name = "AWSTransferSFTPEFSAccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
########################################################################
# AWS-Transfer-Family Policy for user with access to EFS service
########################################################################
resource "aws_iam_role_policy" "AWSTransferSFTPEFSAccessPolicy" {
  name = "AWSTransferSFTPEFSAccessPolicy"
  role = "${aws_iam_role.AWSTransferSFTPEFSAccessRole.id}"
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:*",
                "elasticfilesystem:ClientWrite",
                "elasticfilesystem:ClientMount"
            ],
            "Resource": "*"
        }
    ]
  }
  EOF
}
######################################################
# Attach policys to AWSTransferSFTPEFSAccessRole
######################################################
resource "aws_iam_policy_attachment" "attach_aefscfa" {
  name       = "attach_aefscfa"
  roles      = [aws_iam_role.AWSTransferSFTPEFSAccessRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}

resource "aws_iam_policy_attachment" "attach_atcfa" {
  name       = "attach_atcfa"
  roles      = [aws_iam_role.AWSTransferSFTPEFSAccessRole.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSTransferConsoleFullAccess"
}