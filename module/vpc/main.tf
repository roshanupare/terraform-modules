#Creating Virtual Private Network (VPC)
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = format("%s-%s-vpc", var.project, var.env)
  }
}
#Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_block[count.index]
  availability_zone = var.private_subnet_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = format("%s-%s-private", var.project, var.env)
  }
}
#Creating Public Subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_block[count.index]
  availability_zone = var.public_subnet_availability_zone
  map_public_ip_on_launch = var.public_ip_on_launch

  tags = {
    Name = format("%s-%s-public", var.project, var.env)
  }
}
#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
tags = {
    Name = format("%s-%s-igw", var.project, var.env)
  }
}
#Creating Elastic IP for nat gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = format("%s-%s-eip", var.project, var.env)
  }
}
#Creating Nat Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = format("%s-%s-nat-gw", var.project, var.env)
  }
}
#Creating Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-%s-public-rt", var.project, var.env)
  }
   
}
#Assosiating public subnet to the public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
#Creating Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route = []

  tags = {
    Name = format("%s-%s-private-rt", var.project, var.env)
  }
   
}
#Assosiating private subnet to the private route table
resource "aws_route_table_association" "privat" {
  count = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
#Attaching route nate gatewat to the private route table
resource "aws_route" "nat_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
  depends_on                = [aws_route_table.private_route_table]
}