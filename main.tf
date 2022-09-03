# create VPC

resource "aws_vpc" "example" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"


  tags = {
    Name = "demo"
    Created = "Terrform"
  }
}

# Subnets public Subnet for Load Balancers
resource "aws_subnet" "lb-subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"


  tags = {
    Name = "lb-subnet"
    Created = "Terrform"
  }
}

# App subnet to lauch EC2 instance
resource "aws_subnet" "app-subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"


  tags = {
    Name = "App-subnet"
    Created = "Terrform"
  }
}

# Subnets private for database
resource "aws_subnet" "db-subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"


  tags = {
    Name = "db-subnet"
    Created = "Terrform"
  }
}

# create internet gateway for internet access

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "digital-gateway"
    Created = "Terrform"
  }
}

# create elastic IP

resource "aws_eip" "nat-ip" {
depends_on = [aws_internet_gateway.internet-gw]
  vpc              = true
}

## Create nat gateway for internet access to private subnet

resource "aws_nat_gateway" "default" {
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gw]
  subnet_id = aws_subnet.lb-subnet.id
  allocation_id = aws_eip.nat-ip.id

  tags = {
    Name = "digital-gateway"
    Created = "Terrform"
  }

}