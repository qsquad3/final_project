variable "accesskey" {
 description = "AWS Access Key"
 default = "AKIAxXXXXXXXXXXXXXXXXX
 type = string
}

variable "secretkey" {
 description = "AWS Secret Key"
 default = "rktQJJfAXXXXXXXXXXXXXXXXXXX7Tt7f9"
 type = string
}

variable "ssh_keypair" {
 description = "SSH keypair to use for EC2 instance"
 default = "quode_lab"
 type = string
}

variable "region" {
 description = "AWS region"
 default = "us-east-1"
 type = string
}
