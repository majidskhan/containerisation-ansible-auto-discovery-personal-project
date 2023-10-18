output "bastion-ip" {
  value = module.bastion.bastion-ip
}
output "nexus-ip" {
  value = module.nexus.nexus-ip
}
output "sonarqube-ip" {
  value = module.sonarqube.sonarqube-ip
}
output "jenkins-ip" {
  value = module.jenkins.jenkins-ip
}
# output "ansible-ip" {
#   value = module.ansible.ansible-ip
# }
# output "stage-loadbalancer" {
#   value = module.stage-lb.stage-lb-dns
# }
# output "prod-loadbalancer" {
#   value = module.prod-lb.prod-lb-dns
# }
# output "jenkins-dns" {
#   value = module.jenkins.jenkins-dns
# }