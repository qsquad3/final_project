provider "aws" {
 access_key = var.accesskey
 secret_key = var.secretkey
 region = var.region
}

terraform {
  backend "s3" {
    bucket = var.bucket-s3
    key    = "tf.tfstate"
    region = var.region
  }
}