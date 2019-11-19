variable "aws_access_key" {
    description = "aws access key"
    default = ""
}

variable "aws_secret_key" {
    description = "aws scret key"
    default = ""
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "public_subnet" {
  description = "CIDR for the public subnet"
  default     = "10.1.2.0/24"
}
variable "private_subnet" {
  description = "CIDR for the private subnet"
  default     = "10.1.25.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-00dc79254d0461090"
}