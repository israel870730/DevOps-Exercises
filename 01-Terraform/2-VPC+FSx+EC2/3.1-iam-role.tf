resource "aws_iam_role" "fsx_role" {
  depends_on = [aws_fsx_windows_file_system.windows_file_system]
  name = "fsx_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "fsx_full_access" {
  name       = "FSxFullAccess"
  roles      = [aws_iam_role.fsx_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonFSxFullAccess"
}

resource "aws_iam_policy_attachment" "fsx_console_full_access" {
  name       = "FSxConsoleFullAccess"
  roles      = [aws_iam_role.fsx_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonFSxConsoleFullAccess"
}

resource "aws_iam_policy_attachment" "ssm_managed_instance_core" {
  name       = "SSMManagedInstanceCore"
  roles      = [aws_iam_role.fsx_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "ssm_directory_service_access" {
  name       = "SSMDirectoryServiceAccess"
  roles      = [aws_iam_role.fsx_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}