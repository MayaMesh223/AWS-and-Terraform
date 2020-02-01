# provider
provider "aws" {
  region     = "${var.aws_region}"
}

#resources
# Create vpc
resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    name = "main_vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${var.public_subnet1}"
  availability_zone = "${var.az1}"
  tags = {
    name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${var.public_subnet2}"
  availability_zone = "${var.az2}"
  tags = {
    name = "public_subnet2"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet1" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${var.private_subnet1}"
  availability_zone = "${var.az1}"
  tags = {
    name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${var.private_subnet2}"
  availability_zone = "${var.az2}"
  tags = {
    name = "private_subnet2"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  tags = {
    name = "vpc_igw"
  }
}

# Create route tsble for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags = {
    name = "public_rt"
  }
}

# Route table association for public subnets
resource "aws_route_table_association" "public_rt1" {
  subnet_id      = "${aws_subnet.public_subnet1.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "public_rt2" {
  subnet_id      = "${aws_subnet.public_subnet2.id}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

#Create NAT gateway
resource "aws_instance" "public_nat1" {
  ami                         = "ami-04b9e92b5572fa0d1"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.vpc_sg.id}"]
  subnet_id                   = "${aws_subnet.public_subnet1.id}"
  associate_public_ip_address = true
  tags = {
    Name = "public_nat1"
  }
}

resource "aws_eip" "public_nat1" {
  instance = "${aws_instance.public_nat1.id}"
  vpc      = true
  tags = {
    Name = "public_nat1"
  }
}

resource "aws_instance" "public_nat2" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.vpc_sg.id}"]
  subnet_id                   = "${aws_subnet.public_subnet2.id}"
  associate_public_ip_address = true
  tags = {
    Name = "public_nat2"
  }
}

resource "aws_eip" "public_nat2" {
  instance = "${aws_instance.public_nat2.id}"
  vpc      = true
  tags = {
    Name = "public_nat2"
  }
}

# Create route tables for private subnet
resource "aws_route_table" "private_rt1" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.public_nat1.id}"
  }
  tags = {
    name = "private_rt1"
  }
}

resource "aws_route_table" "private_rt2" {
  vpc_id     = "${aws_vpc.main_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.public_nat2.id}"
  }
  tags = {
    name = "private_rt2"
  }
}

# Route table association for private subnets
resource "aws_route_table_association" "private_rt1" {
  subnet_id      = "${aws_subnet.private_subnet1.id}"
  route_table_id = "${aws_route_table.private_rt1.id}"
}

resource "aws_route_table_association" "private_rt2" {
  subnet_id      = "${aws_subnet.private_subnet2.id}"
  route_table_id = "${aws_route_table.private_rt2.id}"
}

# Public security group (web)

resource "aws_security_group" "vpc_sg" {
  name   = "vpc_sg"
  vpc_id = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "Web Server SG"
  }
}

#private sg (db)

# resource "aws_security_group" "sgdb" {
#   name   = "vpc_db_sg"
#   vpc_id = "${aws_vpc.default.id}"

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["${var.public_subnet}"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["${var.public_subnet}"]
#   }

#   ingress {
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["${var.public_subnet}"]
#   }

#   tags = {
#     name = "DB Server SG"
#   }
# }

# EC2 instances

resource "aws_instance" "web1" {
  ami                         = "${var.ami}"
  instance_type               = "t1.micro"
  subnet_id                   = "${aws_subnet.public_subnet1.id}"
  vpc_security_group_ids      = ["${aws_security_group.vpc_sg.id}"]
  associate_public_ip_address = true
  availability_zone           = "${var.az1}"
  tags = {
    name = "web1"
  }

  connection {
    	type = "ssh"
    	host = "self.public_ip"
	  user = "ubuntu"
	  private_key = "${file("C:\\Maya_Mesh\\.ssh\\Maya.pem")}"
  }
}

resource "aws_instance" "web2" {
  ami                         = "${var.ami}"
  instance_type               = "t1.micro"
  subnet_id                   = "${aws_subnet.public_subnet2.id}"
  vpc_security_group_ids      = ["${aws_security_group.vpc_sg.id}"]
  associate_public_ip_address = true
  availability_zone           = "${var.az2}"
  tags = {
    name = "web2"
  }

  connection {
    type = "ssh"
    host = "self.public_ip"
	  user = "ubuntu"
	  private_key = "${file("C:\\Maya_Mesh\\.ssh\\Maya.pem")}"
  }
}

resource "aws_instance" "db1" {
  ami                    = "${var.ami}"
  instance_type          = "t1.micro"
  subnet_id              = "${aws_subnet.private_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.vpc_sg.id}"]
  availability_zone      = "${var.az1}"

  tags = {
    name = "db1"
  }
}

resource "aws_instance" "db2" {
  ami                    = "${var.ami}"
  instance_type          = "t1.micro"
  subnet_id              = "${aws_subnet.private_subnet2.id}"
  vpc_security_group_ids = ["${aws_security_group.vpc_sg.id}"]
  availability_zone      = "${var.az2}"

  tags = {
    name = "db2"
  }
}
