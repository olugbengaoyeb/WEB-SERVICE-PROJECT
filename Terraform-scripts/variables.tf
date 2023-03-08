# Variables
variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0c94855ba95c71c99" # Amazon Linux 2 LTS
}

variable "public_key" {
  default = "ssh-rsa <public-key>"
}
