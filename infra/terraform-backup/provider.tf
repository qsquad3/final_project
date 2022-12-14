provider "aws" {
  access_key = var.accesskey
  secret_key = var.secretkey
  #profile = "tf12"
  #ssh_keypair = var.ssh_keypair
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-s3quode"
    key    = "tf.tfstate"
    region = "us-east-1"
  }
}
