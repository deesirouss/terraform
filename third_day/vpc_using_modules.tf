module "vpc-demo" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.2"
  
  # VPC Basic Details
  name = "vpc-demo"
  cidr = "10.0.0.0/16"   
  azs                 = ["us-east-2a", "us-east-2b"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24"]

  # Database Subnets
  create_database_subnet_group = true
  create_database_subnet_route_table= true
  database_subnets    = ["10.0.151.0/24", "10.0.152.0/24"]
  
  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    Name = "public-subnets"
  }

  private_subnet_tags = {
    Name = "private-subnets"
  }

  database_subnet_tags = {
    Name = "database-subnets"
  }

  tags = {
    Owner = "bibek"
    Environment = "demo"
  }

  vpc_tags = {
    Name = "vpc-demo"
  }





}
