provider "aws" {
  access_key = var.accesskey
  secret_key = var.secretkey
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "seu-bucket"
    key    = "tf.tfstate"
    region = "us-east-1"
  }
}
