output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "keypair-name" {
  value = aws_key_pair.keypair.key_name
}
output "keypair-id" {
  value = aws_key_pair.keypair.id
}
output "keypair-private" {
  value = tls_private_key.keypair.private_key_pem
}
output "pub-subnet1" {
  value = aws_subnet.pub-subnet1.id
}
output "pub-subnet2" {
  value = aws_subnet.pub-subnet1.id
}
output "prt-subnet1" {
  value = aws_subnet.prt-subnet1.id
}
output "prt-subnet2" {
  value = aws_subnet.prt-subnet2.id
}
output "bastion-sg" {
  value = aws_security_group.bastion-ansible-sg.id
}
output "docker-sg" {
  value = aws_security_group.docker-sg.id
}
output "jenkins-sg" {
  value = aws_security_group.jenkins-sg.id
}
output "sonarqube_sg" {
  value = aws_security_group.sonarqube_sg.id
}
output "nexus-sg" {
  value = aws_security_group.nexus-sg.id
}
output "mysql-sg" {
  value = aws_security_group.mysql-sg.id
}