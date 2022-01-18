# using cidrsubnet and making variable setup more easier to create VPC
- here modules/vpc contains custom scratch modules for VPC with Private and Public Subnets 
> main.tf reuses the modules and create VPC using its own variables from root module directory
