# Creating bastion Host
resource "aws_instance" "bastion" {
  ami                    = var.ami
  vpc_security_group_ids = var.bastion-sg
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  user_data              = <<-EOF
  #!/bin/bash
  echo "pubkeyAcceptedkeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
  systemctl reload sshd
  echo "${var.private_keypair_path}" >> /home/ec2-user/.ssh/id_rsa
  chown ec2-user /home/ec2-user/.ssh/id_rsa
  chgrp ec2-user /home/ec2-user/.ssh/id_rsa
  chmod 600 /home/ec2-user/.ssh/id_rsa
  sudo hostnamectl set-hostname bastion
  EOF
  tags = {
    name = "bastion-server"
  }
}