variable "accesskey" {
 description = "AWS Access Key"
 default = "AKIAXOTEEX6FFAX3VZEC"
 type = string
}

variable "secretkey" {
 description = "AWS Secret Key"
 default = "rktQJJfARnz98bVoqq859FTMKfDWUSKPkE7Tt7f9"
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
