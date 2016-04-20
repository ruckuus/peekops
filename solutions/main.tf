provider "aws" {
  region = "ap-southeast-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

resource "aws_vpc" "vpc_peekops" {
  cidr_block = "192.168.0.0/16"

  tags {
    Name = "vpc_peekops"
  }
}

resource "aws_subnet" "subnet_peekops" {
  vpc_id = "${aws_vpc.vpc_peekops.id}"
  cidr_block = "192.168.99.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "subnet_peekops"
  }
}

resource "aws_security_group" "sg_peekops_web" {

  vpc_id = "${aws_vpc.vpc_peekops.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_peekops_web"
  }
}

resource "aws_security_group" "sg_peekops_app" {

  vpc_id = "${aws_vpc.vpc_peekops.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_peekops_app"
  }
}

resource "aws_security_group" "sg_peekops_cache" {

  vpc_id = "${aws_vpc.vpc_peekops.id}"
  ingress {
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_peekops_cache"
  }
}

resource "aws_security_group" "sg_peekops_db" {

  vpc_id = "${aws_vpc.vpc_peekops.id}"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_peekops_db"
  }
}

resource "aws_key_pair" "key_terraform" {
  key_name = "key_terraform" 
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZoIbsUfcwKXpQVXlCP+6Qf/bCs0WnJiYY8I0iuMaPX+6tMDA9mwRUj6i6gyLhyYa+AVEd1j3MbwJ2oute4Q4Y1QNPZUbC10g9ToYHUp+rCd5x3Jytn8CXztz6Z9KMG+YBy0otjuaeFOFKij0zTuUMZWXYBoKR7q9rKMkedyFMSFRMsjC5kF2oArFJgPAZRBQkWbu9uxYQD6TpGrQnZwPkSbFP1XwX2bZCy0G5XQ+iEbV+y7sS7sL5jitFKg0RKm3yuxKBCT4lyBYdvNVH009Le6IjYtY2xkOhTnADI4nSf5Mu7yU4PIEbAWA4lys84LPoHjZ5ypT3DV6Dle9bgGWZ utianayuba@gmail.com"
}

resource "aws_instance" "inst_peekops_web" {
  ami = "ami-25c00c46"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "key_terraform"
  vpc_security_group_ids = ["${aws_security_group.sg_peekops_web.id}"]
  subnet_id = "${aws_subnet.subnet_peekops.id}"
  private_ip = "192.168.99.101"
  tags {
     Name = "inst_peekops_web"
  }
}

resource "aws_instance" "inst_peekops_app" {
  ami = "ami-25c00c46"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "key_terraform"
  vpc_security_group_ids = ["${aws_security_group.sg_peekops_app.id}"]
  subnet_id = "${aws_subnet.subnet_peekops.id}"
  private_ip = "192.168.99.102"
  tags {
     Name = "inst_peekops_app"
  }
}

resource "aws_instance" "inst_peekops_cache" {
  ami = "ami-25c00c46"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "key_terraform"
  vpc_security_group_ids = ["${aws_security_group.sg_peekops_cache.id}"]
  subnet_id = "${aws_subnet.subnet_peekops.id}"
  private_ip = "192.168.99.103"
  tags {
     Name = "inst_peekops_cache"
  }
}

resource "aws_instance" "inst_peekops_db" {
  ami = "ami-25c00c46"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "key_terraform"
  vpc_security_group_ids = ["${aws_security_group.sg_peekops_db.id}"]
  subnet_id = "${aws_subnet.subnet_peekops.id}"
  private_ip = "192.168.99.104"
  tags {
     Name = "inst_peekops_db"
  }
}
