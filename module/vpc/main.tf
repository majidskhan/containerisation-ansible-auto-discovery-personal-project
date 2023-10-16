# Create a custom VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  tags = {
    Name = var.tag-vpc
  }
}
#  Create Public subnet 01
resource "aws_subnet" "pub-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az1
  cidr_block        = var.public1-cidr
  tags = {
    Name = var.tag-pub-subnet1
  }
}
#  Create Public subnet 02
resource "aws_subnet" "pub-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az2
  cidr_block        = var.public2-cidr
  tags = {
    Name = var.tag-pub-subnet2
  }
}
#  Create Private subnet 01
resource "aws_subnet" "prt-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az1
  cidr_block        = var.private1-cidr
  tags = {
    Name = var.tag-prt-subnet1
  }
}
#  Create Private subnet 02
resource "aws_subnet" "prt-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az2
  cidr_block        = var.private2-cidr
  tags = {
    Name = var.tag-prt-subnet2
  }
}
# Creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.tag-igw
  }
}
# Creating Elastic IP for Nat gateway
resource "aws_eip" "eip" {
  domain = "vpc"
}
# Create Nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub-subnet1.id
  tags = {
    Name = var.tag-nat
  }
}
# Creating public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.public-rt-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.tag-public-rt
  }
}
# Creating private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = var.public-rt-cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = var.tag-private-rt
  }
}
# Attaching public subnet 01 to public route table
resource "aws_route_table_association" "public-rt1" {
  subnet_id      = aws_subnet.pub-subnet1.id
  route_table_id = aws_route_table.public-rt.id
}
# Attaching public subnet 02 to public route table
resource "aws_route_table_association" "public-rt2" {
  subnet_id      = aws_subnet.pub-subnet2.id
  route_table_id = aws_route_table.public-rt.id
}
# Associate private subnet 01 to my private route table
resource "aws_route_table_association" "private-rt1" {
  subnet_id      = aws_subnet.prt-subnet1.id
  route_table_id = aws_route_table.private-rt.id
}
# Associating private subnet 02 to my private route table
resource "aws_route_table_association" "private-rt2" {
  subnet_id      = aws_subnet.prt-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}
# RSA key of size 4096 bits
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "keypair" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}
# Creating keypair
resource "aws_key_pair" "keypair" {
  key_name   = var.keypair-name
  public_key = tls_private_key.keypair.public_key_openssh
}
#Creating Bastion Host and Ansible security group
resource "aws_security_group" "bastion-ansible-sg" {
  name        = "bastion-ansible"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow proxy access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-bastion-ansible-sg
  }
}
#Creating Docker security group
resource "aws_security_group" "docker-sg" {
  name        = "docker"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }

  ingress {
    description = "Allow http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }

  ingress {
    description = "Allow https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-docker-sg
  }
}
#Creating Jenkins security group
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow proxy access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-jenkins-sg
  }
}
#Creating Sonarqube security group
resource "aws_security_group" "sonarqube_sg" {
  name        = "sonarqube"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow sonarqube access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-sonarqube-sg
  }
}

#Creating Nexus security group
resource "aws_security_group" "nexus-sg" {
  name        = "nexus"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow ssh Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow nexus access"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  ingress {
    description = "Allow nexus access"
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-nexus-sg
  }
}
#Creating MSQL RDS Database security group
resource "aws_security_group" "mysql-sg" {
  name        = "mysql-rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow MYSQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.public-rt-cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public-rt-cidr]
  }
  tags = {
    Name = var.tag-mysql-sg
  }
}