terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lf-tf-demo"

    workspaces {
      name       = "cli-tf-lf-demo_new"
    }
  }
}
