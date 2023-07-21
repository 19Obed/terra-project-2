#creating aws porovider

resource "aws_vpc" "website" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "website"
  }
}

#public subnets

resource "aws_subnet" "web-public-subnet1" {
  vpc_id            = aws_vpc.website.id
  availability_zone = var.az1
  cidr_block        = var.pub_sub_cidr1

  tags = {
    Name = "Web-public-subnet1"
  }
}


resource "aws_subnet" "web-public-subnet2" {
  vpc_id            = aws_vpc.website.id
  availability_zone = var.az2
  cidr_block        = var.pub_sub_cidr2

  tags = {
    Name = "Web-public-subnet2"
  }
}


#private subnets 

resource "aws_subnet" "app-private-subnet1" {
  vpc_id            = aws_vpc.website.id
  availability_zone = var.az3
  cidr_block        = var.priv_app_sub_cidr1

  tags = {
    Name = "app-private-subnet1"
  }
}


resource "aws_subnet" "app-private-subnet2" {
  vpc_id            = aws_vpc.website.id
  availability_zone = var.az4
  cidr_block        = var.priv_app_sub_cidr2

  tags = {
    Name = "app-private-subnet2"
  }
}


#public route table 

resource "aws_route_table" "website-public-route" {
  vpc_id = aws_vpc.website.id

  tags = {
    Name = "website-public-route"
  }
}

#private route table

resource "aws_route_table" "website-private-route" {
  vpc_id = aws_vpc.website.id

  tags = {
    Name = "website-private-route"
  }
}

#associating public route table to public subnet

resource "aws_route_table_association" "website-public-RTA" {
  subnet_id      = aws_subnet.web-public-subnet1.id
  route_table_id = aws_route_table.website-public-route.id
}

resource "aws_route_table_association" "website-public-RTA2" {
  subnet_id      = aws_subnet.web-public-subnet2.id
  route_table_id = aws_route_table.website-public-route.id
}

#associating private route table to private subnet

resource "aws_route_table_association" "website-private-RTA" {
  subnet_id      = aws_subnet.app-private-subnet1.id
  route_table_id = aws_route_table.website-private-route.id
}

resource "aws_route_table_association" "website-private-RTA2" {
  subnet_id      = aws_subnet.app-private-subnet2.id
  route_table_id = aws_route_table.website-private-route.id
}

#internet gateway

resource "aws_internet_gateway" "website-IGW" {
  vpc_id = aws_vpc.website.id

  tags = {
    Name = "website-IGW"
  }
}

#associating route table with internet gateway

resource "aws_route_table_association" "website-IGW-association" {
  gateway_id     = aws_internet_gateway.website-IGW.id
  route_table_id = aws_route_table.website-public-route.id
}

#Elastic IP

resource "aws_eip" "website-eip" {

  depends_on = [aws_internet_gateway.website-IGW]
}

resource "aws_eip" "website-eip2" {

  depends_on = [aws_internet_gateway.website-IGW]
}


#NAT gateway

resource "aws_nat_gateway" "website-Nat-gateway" {
  allocation_id = aws_eip.website-eip2.id
  subnet_id     = aws_subnet.web-public-subnet1.id

  tags = {
    Name = "website-NAT-gateway"
  }
}

resource "aws_nat_gateway" "website-Nat-gateway2" {
  allocation_id = aws_eip.website-eip.id
  subnet_id     = aws_subnet.web-public-subnet2.id

  tags = {
    Name = "website-NAT-gateway2"
  }
}
