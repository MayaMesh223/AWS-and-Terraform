provider "aws" {
  access_key = "my-access-key"
  secret_key = "my-secret-key"
  region     = "us-east-1"
}

resource "aws_security_group" "sg_22_80" {
  name = "sg_22"
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
	
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
	host = "self.public_ip"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
}

resource "aws_instance" "ec2-2" {
  ami = "ami-2757f631"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.sg_22_80.id}"]
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
	
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
  
  connection {
    type = "ssh"
    user = "ubuntu"
	host = "self.public_ip"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
 }