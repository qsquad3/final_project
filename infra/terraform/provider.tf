provider "aws" {
 access_key = var.accesskey
 secret_key = var.secretkey
 region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-project"
    key    = "tf.tfstate"
    region = "us-east-1"
  }
}