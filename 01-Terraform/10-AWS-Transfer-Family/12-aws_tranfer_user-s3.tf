# Crear el usuario SFTP para S3
resource "aws_transfer_user" "sftp_s3_user" {
  server_id   = aws_transfer_server.sftp_transfer_server.id
  user_name   = "s3_user"
  role        = aws_iam_role.AWSTransferSFTPS3AccessRole.arn
  home_directory = "/${aws_s3_bucket.demo.bucket}/s3_user"
}

resource "aws_transfer_ssh_key" "aws_transfer_ssh_key_s3" {
  server_id = aws_transfer_server.sftp_transfer_server.id
  user_name = aws_transfer_user.sftp_s3_user.user_name
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxnFzqLHcM5oAkGOwE+bkDO9YSD3gDzrTH8kJTYlD0UUDhdN3dtwEMh60hhan2Vr/Jvsa9eo/I/tZkdjl9b2GqRTpynjUC/Lo+nVhJqQ5+drWW0w98MVjXYwfkjqJ+Szg+u+MlL8kjTchFP6mrBEO50g7jpeVFquuD5r7JQIChVxBDKek9+XWWP3w7lfgq45Rzjd7tXXLNC9IYLoaetW4scF0QVxxQKPLRsVTSIU9YqE8Pf0RzbBs+CODfEo1Xpn+dcer7s8tXTV0jw3Aprz2vtCAsprNy3XrCD4Uh2llHePwGP2MYTTOpH7RnqSsVTWyXN/Ahtgd9fHjXhffGh0ml rsa-key-20240820"
}