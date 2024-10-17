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
  # Si es usuario de windows estas llaves se generan usando el "PuTTygen", en linux usando el comando "ssh-keygen"
  # salida del comando 'cat .ssh/id_rsa.pub
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcVehcIkUslVrdi2/PXHUda6jmRwqGxGvB2obqsnM0mLH1lxy/CiqsgwEvMQAzSI2KDFdMypMi7QQ/w/aKtb6zQcm8KJ2VMfqlnkC5ySuIJkrVA86uEEFQGZAsAKAik8zbvbAKEUGApjjks31T8KsIchYAs9yyxNYqcI4i2JQCOIq8oBmWxZG+JKLtUVtzFljh9YYxCg48/IWBgXUIHPAZ6C+CogBwu09M7TUp/HWgc4z+Ksph/xWybFHOagKoC+Le1bHpY3duLtZYvc0yOEi4QoTYMZFxLLpuRuLl7UFSwbFyuy9Axxgui//EpS/IoFk12nPeKWQ5N7ta5v6zNF/OQb1ojdMbP9yFIvGu1ivDZQlq4ZC8DBc8EA0dJwG+ZQQfDW4XFIIar9bqZT+Cuo5haKZzaS8UMXKaNnDkXlNAbjZGDUCvRQJV+AGBu2nAyTUm4doYxOjR8V8uThu23NKmWQmXzk0m87LpMdPG40IVlbwrk82p8/3ML9g9orW/L10= root@ip-10-0-67-117.us-west-1.compute.internal"
}