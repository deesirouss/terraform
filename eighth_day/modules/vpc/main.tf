data "aws_availability_zones" "default" {}

# VPC configuration

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway needed for Public Subnets Configuration

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Elastic IP needed for NAT

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
  
  tags = {
    Name     = "${var.environment}-nat_eip"
  }
}

# NAT configuration needed for Private Subnets

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.ig]
  
  tags = {
    Name        = "nat"
    Environment = var.environment
  }
}

# Configuration for Public Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.default.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index}"
    Environment = var.environment
  }
}

# Configuration for Private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 2)
  availability_zone       = data.aws_availability_zones.default.names[count.index]
  #map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index}"
    Environment = var.environment
  }
}


# Routing table for private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }
}

# Adding route to Private Rout Table - NAT Gateway

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Private Route Table Association

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


# Routing table for public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Adding route to Public Rout Table - Internate Gateway

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Public Route table associations
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
