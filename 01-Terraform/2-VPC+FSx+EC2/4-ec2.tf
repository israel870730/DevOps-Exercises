# ec2 instances para montar el FSx

resource "aws_iam_instance_profile" "fsx_instance_profile" {
  name = "poc_profile_fsx"
  role = aws_iam_role.fsx_role.name
}

resource "aws_instance" "fsx_instance" {
  count                  = 2
  ami                    = "ami-01ada1ffbddb04f3c" 
  instance_type          = "t2.medium" 
  #iam_instance_profile   = aws_iam_instance_profile.fsx_instance_profile.name
  key_name               = "demo-efs"

  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address= true
  vpc_security_group_ids = [aws_security_group.ec2.id]

  # user_data = <<-EOF
  #   <powershell>
  #   $secpasswd = ConvertTo-SecureString "${var.ad_password}" -AsPlainText -Force
  #   $domaincreds = New-Object System.Management.Automation.PSCredential ("Admin", $secpasswd)
  #   New-SmbGlobalMapping -RemotePath "\\${aws_fsx_windows_file_system.windows_file_system.dns_name}\share" -Credential $domaincreds -LocalPath Z:
  #   </powershell>
  #   <persist>true</persist>
  # EOF
}