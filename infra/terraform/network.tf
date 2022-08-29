# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc
tags = {
    Name = "VPC"
  }
}

# Subnet Priv
resource "aws_subnet" "pri-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pri-subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Subnet Publica
resource "aws_subnet" "pub-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "PubSubnet"
  }
}
resource "aws_subnet" "pub-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-subnet2
  availability_zone = "us-east-1b"

  tags = {
    Name = "PubSubnet2"
  }
}

# Subnet Developer
resource "aws_subnet" "dev-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.dev-subnet
  availability_zone = "us-east-1a"

  tags = {
    Name = "DevSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "InternetGW"
  }
}

# Route Table
resource "aws_route_table" "rtpub" {
  vpc_id = aws_vpc.vpc.id

  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
   }

  tags = {
    Name = "RouteTable-Pub"
  }
}

# Associate subnet with Route Table
 resource "aws_route_table_association" "pub" {
   subnet_id      = aws_subnet.pub-subnet.id
   route_table_id = aws_route_table.rtpub.id
 }
 resource "aws_route_table_association" "pub2" {
   subnet_id      = aws_subnet.pub-subnet2.id
   route_table_id = aws_route_table.rtpub.id
 }

 # Interfaces de rede
 # K8s-Master
 resource "aws_network_interface" "k8s-master-nic" {
   subnet_id       = aws_subnet.pub-subnet.id
   private_ips     = [var.k8smaster-nic]
   security_groups = [aws_security_group.default-sg.id]

}
# IP publico 
 resource "aws_eip" "one" {
   vpc                       = true
   network_interface         = aws_network_interface.k8s-master-nic.id
   associate_with_private_ip = var.k8smaster-nic
   depends_on                = [aws_internet_gateway.gw]
 }

# K8s-Worker1
 resource "aws_network_interface" "k8s-worker1-nic" {
   subnet_id       = aws_subnet.pub-subnet.id
   private_ips     = [var.k8sworker1-nic]
   security_groups = [aws_security_group.default-sg.id]
 }
 # IP publico 
 resource "aws_eip" "two" {
   vpc                       = true
   network_interface         = aws_network_interface.k8s-worker1-nic.id
   associate_with_private_ip = var.k8sworker1-nic
   depends_on                = [aws_internet_gateway.gw]
 }
 #K8s-Worker2
 resource "aws_network_interface" "k8s-worker2-nic" {
   subnet_id       = aws_subnet.pub-subnet.id
   private_ips     = [var.k8sworker2-nic]
   security_groups = [aws_security_group.default-sg.id]
 }
 # IP publico 
 resource "aws_eip" "three" {
   vpc                       = true
   network_interface         = aws_network_interface.k8s-worker2-nic.id
   associate_with_private_ip = var.k8sworker2-nic
   depends_on                = [aws_internet_gateway.gw]
 }
# DockerServer
 resource "aws_network_interface" "docker-nic" {
   subnet_id       = aws_subnet.pub-subnet.id
   private_ips     = [var.docker-nic]
   security_groups = [aws_security_group.default-sg.id]
}
# IP Publico
 resource "aws_eip" "four" {
   vpc                       = true
   network_interface         = aws_network_interface.docker-nic.id
   associate_with_private_ip = var.docker-nic
   depends_on                = [aws_internet_gateway.gw]
 }