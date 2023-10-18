# Creating a Sonarqube Server
resource "aws_instance" "sonarqube-server" {
  ami                    = var.ami
  vpc_security_group_ids = var.security_groups
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  user_data             = local.sonarqube_user_data
  tags = {
    name =var.tags
  }
}