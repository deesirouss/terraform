variable "availability_zones" {
  type    = list
  default = ["us-east-2a", "us-east-2b"]
}

variable "vpc_cidr" {
  description = "VPC default CIDR"
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "VPC default instance_tenancy"
  default     = "dedicated"
}

variable "environment" {
  description = "default environment"
  default     = "demo"
}

variable "public_subnets_cidr" {
  description = "list of public subnets"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "list of private subnets"
  type        = list
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets_cidr" {
  description = "list of database subnets"
  type        = list
  default     = ["10.0.103.0/24", "10.0.104.0/24"]
}
