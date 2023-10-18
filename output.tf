output "bastion-ip" {
  value = module.bastion.bastion
}
output "nexus-ip" {
  value = module.nexus.nexus-server
}
output "sonarqube-ip" {
  value = module.sonarqube.sonarqube-ip
}