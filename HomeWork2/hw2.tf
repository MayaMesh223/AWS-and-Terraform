provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    name = "web_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet}"
  availability_zone = "us-east-1a"
  tags {
    name = "web_public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet}"
  availability_zone = "us-east-1a"
  tags {
    name = "db_private_subnet"
   }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    name = "vpc_igw"
   }
}

resource "aws_route_table" "web_public_rt" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
  tags {
    name = "public_subnet_rt"
   }
}

resource "aws_route_table_association" "web_public_rt" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.web_public_rt.id}"
}

resource "aws_security_group" "sgweb" {
  
}




# resource "aws_security_group" "sg_22_80" {
#   name = "sg_22"
#   #vpc_id = aws_default_vpc.default.id

#   ingress {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "ec2-1" {
#   ami = "ami-2757f631"
#   instance_type = "t2.medium"
#   vpc_security_group_ids = ["${aws_security_group.sg_22_80.id}"]
#   tags = {
# 	name = "ec2-1"
# 	owner = "me"
# 	purpose = "study"
# 	}
  
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 10
#   }
  
#   ebs_block_device {
#     device_name = "/dev/sda1"  
# 	volume_size = 10
# 	encrypted = true
# 	volume_type = "gp2"
# 	delete_on_termination = true
# 	}
  
#   connection {
#     type = "ssh"
#     user = "ec2-user"
# 	host = "self.public_ip"
#     private_key = "${file("~/.ssh/id_rsa")}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo amazon-linux-extras enable nginx1.12",
#       "sudo yum -y install nginx",
#       "sudo systemctl start nginx",
#     ]
#   }
  
# }

# resource "aws_instance" "ec2-2" {
#   ami = "ami-2757f631"
#   instance_type = "t2.medium"
#   tags = {
# 	name = "ec2-2"
# 	owner = "Maya"
# 	purpose = "learn"
# 	}
  
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = 10
#   }
  
#   ebs_block_device {
#     device_name = "/dev/sdg"  
# 	volume_size = 10
# 	encrypted = true
# 	volume_type = "gp2"
# 	delete_on_termination = true
# 	}

#   connection {
#     type = "ssh"
#     user = "ec2-user"
# 	host = "self.public_ip"
#     private_key = "${file("~/.ssh/id_rsa")}"
#   }
  
#   provisioner "remote-exec" {
#     inline = [
#       "sudo amazon-linux-extras enable nginx1.12",
#       "sudo yum -y install nginx",
#       "sudo systemctl start nginx",
#     ]
#   }
#  }