# Crear el usuario SFTP para EFS
resource "aws_transfer_user" "sftp_efs_user" {
  server_id   = aws_transfer_server.sftpefs_transfer_server.id
  user_name   = "efs_user"
  role        = aws_iam_role.AWSTransferSFTPEFSAccessRole.arn
  home_directory = "/${aws_efs_file_system.demo.id}/efs_user"

  # Definiendo el POSIX Profile
  posix_profile {
    uid = 0
    gid = 0
    secondary_gids = [0] # Opcional
  }
}

resource "aws_transfer_ssh_key" "aws_transfer_ssh_key_efs" {
  server_id = aws_transfer_server.sftpefs_transfer_server.id
  user_name = aws_transfer_user.sftp_efs_user.user_name
  # Si es usuario de windows estas llaves se generan usando el "PuTTygen", en linux usando el comando "ssh-keygen" 
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxnFzqLHcM5oAkGOwE+bkDO9YSD3gDzrTH8kJTYlD0UUDhdN3dtwEMh60hhan2Vr/Jvsa9eo/I/tZkdjl9b2GqRTpynjUC/Lo+nVhJqQ5+drWW0w98MVjXYwfkjqJ+Szg+u+MlL8kjTchFP6mrBEO50g7jpeVFquuD5r7JQIChVxBDKek9+XWWP3w7lfgq45Rzjd7tXXLNC9IYLoaetW4scF0QVxxQKPLRsVTSIU9YqE8Pf0RzbBs+CODfEo1Xpn+dcer7s8tXTV0jw3Aprz2vtCAsprNy3XrCD4Uh2llHePwGP2MYTTOpH7RnqSsVTWyXN/Ahtgd9fHjXhffGh0ml rsa-key-20240820"
}