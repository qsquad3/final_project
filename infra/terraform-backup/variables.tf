variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "instancia" {
  description = "Tipo Instancia"
  default     = "t3.large"
  type        = string
}
variable "vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "pri-subnet" {
  type    = string
  default = "10.0.1.0/24"
}
variable "dev-subnet" {
  type    = string
  default = "10.0.2.0/24"
}
variable "pub-subnet" {
  type    = string
  default = "10.0.3.0/24"
}
variable "pub-subnet2" {
  type    = string
  default = "10.0.4.0/24"
}
variable "k8smaster-nic" {
  type    = string
  default = "10.0.3.11"
}
variable "k8sworker1-nic" {
  type    = string
  default = "10.0.3.12"
}
variable "k8sworker2-nic" {
  type    = string
  default = "10.0.3.13"
}
variable "docker-nic" {
  type    = string
  default = "10.0.3.14"
}
variable "project" {
  type    = string
  default = "projeto-final"
}
