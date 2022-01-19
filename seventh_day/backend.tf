terraform {
  backend "local" {
    path = "./localstate.tfstate"
  }
}
