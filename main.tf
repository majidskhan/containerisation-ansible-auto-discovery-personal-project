locals {
  name = "perprjt1"
}

module "vpc" {
  source = "./module/vpc"
  keypair-name = "eu2acp"
  az1 = "eu-west-3a"
  az2 = "eu-west-3b"
  vpc-cidr = "10.0.0.0/16"
  public1-cidr = "10.0.1.0/24"
  public2-cidr = "10.0.2.0/24"
  private1-cidr = "10.0.3.0/24"
  private2-cidr = "10.0.4.0/24"
  public-rt-cidr = "0.0.0.0/24"
  tag-vpc = "${local.name}-vpc"
  tag-pub-subnet1 = "${local.name}-subnet1"
  tag-pub-subnet2 = "${local.name}-subnet2"
  tag-prt-subnet1 = "${local.name}-subnet1"
  tag-prt-subnet2 = "${local.name}-subnet2"
  tag-igw = "${local.name}-igw"
  tag-nat = "${local.name}-nat"
  tag-public-rt = "${local.name}-pub-rt"
  tag-private-rt = "${local.name}-prt-rt"
  tag-bastion-ansible-sg = "${local.name}-bastion-ansible-sg"
  tag-docker-sg = "${local.name}-docker-sg"
  tag-jenkins-sg = "${local.name}-jenkins-sg"
  tag-nexus-sg = "${local.name}-nexus-sg"
  tag-sonarqube-sg = "${local.name}-sonarqube-sg"
  tag-mysql-sg = "${local.name}-mysql-sg"
}