- here modules/vpc contains custom scratch modules for creating 3-tier VPC(Public and Private Subnets)
  - used cidrsubnet function
  - local backend to store tfstate files in particular location in first commit
  - s3 backend to store state files in AWS bucket in second commit
> main.tf reuses the modules and create VPC using its own variables from root module directory
