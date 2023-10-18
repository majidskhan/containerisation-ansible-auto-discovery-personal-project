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
  public-rt-cidr = "0.0.0.0/0"
  tag-vpc = "${local.name}-vpc"
  tag-pub-subnet1 = "${local.name}-pub-subnet1"
  tag-pub-subnet2 = "${local.name}-pub-subnet2"
  tag-prt-subnet1 = "${local.name}-prvt-subnet1"
  tag-prt-subnet2 = "${local.name}-prvt-subnet2"
  tag-igw = "${local.name}-igw"
  tag-nat = "${local.name}-nat"
  tag-public-rt = "${local.name}-pub-rt"
  tag-private-rt = "${local.name}-prvt-rt"
  tag-bastion-ansible-sg = "${local.name}-bastion-ansible-sg"
  tag-docker-sg = "${local.name}-docker-sg"
  tag-jenkins-sg = "${local.name}-jenkins-sg"
  tag-nexus-sg = "${local.name}-nexus-sg"
  tag-sonarqube-sg = "${local.name}-sonarqube-sg"
  tag-mysql-sg = "${local.name}-mysql-sg"
}

module "bastion" {
  source = "./module/bastion"
  ami = "ami-0e04728db873b194c"
  instance_type = "t2.micro"
  bastion-sg = [module.vpc.bastion-sg]
  key_name = module.vpc.keypair-name
  subnet_id = module.vpc.pub-subnet1
  private_keypair_path = module.vpc.keypair-private
  tags = "${local.name}-bastion-server"
}

module "nexus" {
  source = "./module/nexus"
  ami = "ami-0e04728db873b194c"
  instance_type = "t2.medium"
  security_groups = [module.vpc.nexus-sg]
  key_name = module.vpc.keypair-name
  subnet_id = module.vpc.pub-subnet2
  tags = "${local.name}-nexus-server"
  newrelic-user-licence = "NRAK-BIXF3NWDTURHEHFOGCNNANRA0V0"
  newrelic-acct-id      = 3947187
}

module "sonarqube" {
  source = "./module/sonarqube"
  ami = "ami-05b5a865c3579bbc4"
  instance_type = "t2.medium"
  security_groups = [module.vpc.sonarqube_sg]
  key_name = module.vpc.keypair-name
  subnet_id = module.vpc.pub-subnet1
  tags = "${local.name}-sonarqube-server"
  newrelic-user-licence = "NRAK-BIXF3NWDTURHEHFOGCNNANRA0V0"
  newrelic-acct-id      = 3947187
}

module "jenkins" {
  source = "./module/jenkins"
  ami = "ami-0e04728db873b194c"
  instance_type = "t2.medium"
  security_groups = [module.vpc.jenkins-sg]
  key_name = module.vpc.keypair-name
  subnet_id = module.vpc.prt-subnet1
  nexus-ip = module.nexus.nexus-ip
  tags = "${local.name}-jenkins-server"
  jenkins-elb = "${local.name}-jenkins-elb"
  subnetid = [module.vpc.pub-subnet1]
  newrelic-user-licence = "NRAK-BIXF3NWDTURHEHFOGCNNANRA0V0"
  newrelic-acct-id      = 3947187
}