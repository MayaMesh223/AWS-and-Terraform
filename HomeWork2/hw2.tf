#provider

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#resources

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

#public sg (web)

resource "aws_security_group" "sgweb" {
  name = "vpc_web_sg"
  vpc_id = "${aws_vpc.default.id}"

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
  tags {
    name = "Web Server SG"
  }
}

#private sg (db)

resource "aws_security_group" "sgdb" {
  name = "vpc_db_sg"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["${var.public_subnet}"]
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${var.public_subnet}"]
  }

  ingress {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["${var.public_subnet}"]
  }
  
  tags {
    name = "DB Server SG"
  }
}

#instances

resource "aws_instance" "web1" {
  ami = "${var.ami}"
  instance_type = "t1.micro"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  availability_zone = "${var.az1.default}"
  tags = {
	  name = "web1"
		}
}

resource "aws_instance" "web2" {
  ami = "${var.ami}"
  instance_type = "t1.micro"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  availability_zone = "${var.az2.default}"
  tags = {
	  name = "web2"
		}
}

resource "aws_instance" "db1" {
  ami = "${var.ami}"
  instance_type = "t1.micro"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
  availability_zone = "${var.az1.default}"
  
  tags = {
	  name = "db1"
		}
}   

resource "aws_instance" "db2" {
  ami = "${var.ami}"
  instance_type = "t1.micro"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
  availability_zone = "${var.az2.default}"
  
  tags = {
	  name = "db2"
		}
}