provider "aws" {
  access_key    = var.access_key
  secret_key    = var.secret_key
  token         = var.token_id
  region        = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-02bd262766f4f24c2"
  instance_type = "t2.micro"
}
