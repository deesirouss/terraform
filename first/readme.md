to initialize the configuration file
> terraform init
create execution plan and save the plan in output.terraform file
> terraform plan -out=output.terraform
to apply the changes
> terraform apply output.terraform
note: var.tfvars is ignored to upload in git repo for security reason
