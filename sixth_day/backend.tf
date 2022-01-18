terraform {
  backend "remote" {
    organization = "lf-tf-demo"
    token        = ".."

    workspaces {
      name = "cli-tf-lf-demo"
    }
  }
}
