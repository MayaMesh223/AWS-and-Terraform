provider "aws" {
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  region     = "us-east-1"
}

resource "aws_instance" "ec2-1" {
  ami = "ami-2757f631"
  instance_type = "t2.medium"
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
 }