variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}

variable "az1" {
  description = "AWS az"
  default     = "us-east-1a"
}

variable "az2" {
  description = "AWS az"
  default     = "us-east-1b"
}

variable "public_subnet1" {
  description = "CIDR for the public subnet"
  default     = "10.1.2.0/24"
}

variable "public_subnet2" {
  description = "CIDR for the public subnet"
  default     = "10.1.3.0/24"
}

variable "private_subnet1" {
  description = "CIDR for the private subnet"
  default     = "10.1.25.0/24"
}

variable "private_subnet2" {
  description = "CIDR for the private subnet"
  default     = "10.1.35.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-04b9e92b5572fa0d1"
}