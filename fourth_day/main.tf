module "vpc_demo" {
source = "./modules/vpc"
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  database_subnets_cidr = var.database_subnets_cidr
 # instance_tenancy      = var.instance_tenancy
}
