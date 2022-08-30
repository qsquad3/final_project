provider "aws" {
  access_key = var.accesskey
  secret_key = var.secretkey
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "SEU-BUCKET-S3"
    key    = "tf.tfstate"
    region = "us-east-1"
  }
}
