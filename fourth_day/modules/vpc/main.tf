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
  count                   = "${length(var.public_subnets_cidr)}"
  cidr_block              = "${element(var.public_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index}"
    Environment = var.environment
  }
}

# Configuration for Private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  #map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index}"
    Environment = var.environment
  }
}

# Configuration for Database subnet

resource "aws_subnet" "database_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = "${length(var.database_subnets_cidr)}"
  cidr_block              = "${element(var.database_subnets_cidr, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  #map_public_ip_on_launch = false
  tags = {
    Name        = "${var.environment}-database-subnet-${count.index}"
    Environment = var.environment
  }
}


# Creating Database Subnet Group

resource "aws_db_subnet_group" "db_subnet_grp" {
  name              = "${var.environment}-db_subnet"
  subnet_ids        = aws_subnet.database_subnet.*.id

  tags = {
    Name = "${var.environment}-subnet_group"
    Environment = var.environment
  }
}

# Routing table for databse subnet

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-database-route-table"
    Environment = var.environment
  }
}

# Database Route Table Association

resource "aws_route_table_association" "database" {
  count          = "${length(var.database_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.database_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.database.id
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
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
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
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.public.id
}
