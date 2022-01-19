module "vpc_demo" {
source = "./modules/vpc"
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
}
