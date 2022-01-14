# Providers variables
variable "access_key" {}
variable "secret_key" {}
variable "token_id" {}

#main.tf variables
## Create Variable for S3 Bucket Name
variable "my_s3_bucket" {
  description = "S3 Bucket name that we pass to S3 Custom Module"
  type = string
  default = "mybucket-demo-lf"
}

## Create Variable for S3 Bucket Tags
variable "my_s3_tags" {
  description = "Tags to set on the bucket"
  type = map(string)
  default = {
    Terraform = "true"
    Environment = "demo"
  }
}
