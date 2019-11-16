# variables

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "us-east-1"
}

# provider

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# resources 

resource "aws_security_group" "sg_22_80" {
  name = "sg_22"
  vpc_id = aws_default_vpc.default.id

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-1" {
  ami = "ami-2757f631"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.sg_22_80.id}"]
  tags = {
	name = "ec2-1"
	owner = "me"
	purpose = "study"
	}
  
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }
  
  ebs_block_device {
    device_name = "/dev/sda1"  
	volume_size = 10
	encrypted = true
	volume_type = "gp2"
	delete_on_termination = true
	}
  
  connection {
    type = "ssh"
    user = "ec2-user"
	host = "self.public_ip"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
  
}

resource "aws_instance" "ec2-2" {
  ami = "ami-2757f631"
  instance_type = "t2.medium"
  tags = {
	name = "ec2-2"
	owner = "Maya"
	purpose = "learn"
	}
  
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }
  
  ebs_block_device {
    device_name = "/dev/sdg"  
	volume_size = 10
	encrypted = true
	volume_type = "gp2"
	delete_on_termination = true
	}

  connection {
    type = "ssh"
    user = "ec2-user"
	host = "self.public_ip"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
 }