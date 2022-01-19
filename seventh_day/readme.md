- here modules/vpc contains custom scratch modules for creating 3-tier VPC(Public and Private Subnets)
  - used cidrsubnet function
  - local backend to store tfstate files in particular location
> main.tf reuses the modules and create VPC using its own variables from root module directory
