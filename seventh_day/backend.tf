terraform {
  backend "s3" {
    bucket         = "lf-tf-demo"
    key            = "remote.tfstate" 
    region         = "us-east-2"
    profile        = "lf-training"
    dynamodb_table = "lf-tf-demo"
    encrypt        = true
    acl            = "private"
  }
}
