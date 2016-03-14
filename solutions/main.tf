provider "aws" {
  region = "ap-southeast-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

resource "aws_vpc" "peekops_main" {
  cidr_block = "10.10.0.0/16"

  tags {
    Name = "peekops_main"
  }
}

resource "aws_subnet" "peekops_main_nat" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "peekops_main_app_a"
  }
}

resource "aws_subnet" "peekops_main_app_a" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "peekops_main_app_a"
  }
}

resource "aws_subnet" "peekops_main_app_b" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1b"

  tags {
    Name = "peekops_main_app_b"
  }
}

resource "aws_subnet" "peekops_main_db_a" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.20.0/24"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "peekops_main_db_a"
  }
}

resource "aws_subnet" "peekops_main_db_b" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.21.0/24"
  availability_zone = "ap-southeast-1b"

  tags {
    Name = "peekops_main_db_b"
  }
}

resource "aws_subnet" "peekops_main_elb_a" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.30.0/24"
  availability_zone = "ap-southeast-1a"

  tags {
    Name = "peekops_main_db_a"
  }
}

resource "aws_subnet" "peekops_main_elb_b" {
  vpc_id = "${aws_vpc.peekops_main.id}"
  cidr_block = "10.10.31.0/24"
  availability_zone = "ap-southeast-1b"

  tags {
    Name = "peekops_main_db_b"
  }
}

resource "aws_internet_gateway" "peekops_igw" {
  vpc_id = "${aws_vpc.peekops_main.id}"

  tags {
    Name = "peekops_main_igw"
  }
}

resource "aws_route_table" "route_main" {
  vpc_id = "${aws_vpc.peekops_main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.peekops_igw.id}"
  }

  tags {
    Name = "peekops_main_route"
  }
}

resource "aws_route_table" "route_app" {
  vpc_id = "${aws_vpc.peekops_main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.peekops_igw.id}"
  }

  tags {
    Name = "peekops_main_route_app"
  }
}

resource "aws_route_table_association" "app_a" {
  subnet_id = "${aws_subnet.peekops_main_app_a.id}"
  route_table_id = "${aws_route_table.route_app.id}"
}

resource "aws_main_route_table_association" "peekops_main_route" {
    vpc_id = "${aws_vpc.peekops_main.id}"
    route_table_id = "${aws_route_table.route_main.id}"
}

resource "aws_route_table_association" "app_b" {
  subnet_id = "${aws_subnet.peekops_main_app_b.id}"
  route_table_id = "${aws_route_table.route_app.id}"
}

resource "aws_security_group" "peekops_bastion" {

  vpc_id = "${aws_vpc.peekops_main.id}"
  ingress {
    from_port = 22
    to_port = 22
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
    Name = "peekops_main_bastion"
  }
}

resource "aws_security_group" "peekops_elb" {

  vpc_id = "${aws_vpc.peekops_main.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
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
    Name = "peekops_main_elb"
  }
}

resource "aws_security_group" "peekops_main_app" {
  name = "peekops_main_app"
  description = "Security group for app servers."
  vpc_id = "${aws_vpc.peekops_main.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.peekops_bastion.id}", "${aws_security_group.peekops_elb.id}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.peekops_bastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "peekops_main_app"
  }
}

resource "aws_elb" "peekops_web" {
  name = "peekops-web"

  subnets = ["${aws_subnet.peekops_main_elb_a.id}","${aws_subnet.peekops_main_elb_b.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

resource "aws_launch_configuration" "peekops_app" {
  name = "peekops-launch-cf"
  image_id = "ami-eea6678d"
  instance_type = "t2.micro"
  key_name = "terraform"
  security_groups = ["${aws_security_group.peekops_main_app.id}"]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "peekops_app" {
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
  name = "peekops-asg"
  max_size = 5
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 3
  force_delete = true
  launch_configuration = "${aws_launch_configuration.peekops_app.name}"
  load_balancers = ["${aws_elb.peekops_web.name}"]
  vpc_zone_identifier = ["${aws_subnet.peekops_main_app_a.id}","${aws_subnet.peekops_main_app_b.id}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Group"
    value = "PeekOps Autoscaling Group."
    propagate_at_launch = true
  }
}

resource "aws_instance" "bastion" {
  connection {
    user = "ubuntu"
    key_file = "/path/to/private/key/terraform.pem"
  }

  ami = "ami-YOURAMIID"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "terraform"
  vpc_security_group_ids = ["${aws_security_group.peekops_bastion.id}"]
  subnet_id = "${aws_subnet.peekops_main_nat.id}"
  tags {
     Name = "peekops_bastion"
  }
}

#### Application
resource "aws_instance" "application" {
  connection {
    user = "ubuntu"
    key_file = "/path/to/private/key/terraform.pem"
  }

  ami = "ami-YOURAMIID"
  instance_type = "t2.micro"
  availability_zone = ""
  ebs_optimized = "false"
  disable_api_termination = "true"
  instance_initiated_shutdown_behavior = "stop"
  key_name = "terraform"
  vpc_security_group_ids = ["${aws_security_group.peekops_main_app.id}"]
  subnet_id = "${aws_subnet.peekops_main_app_a.id}"
  tags {
     Name = "peekops_application"
  }
}

##### Web
##### DB (You will need to launch RDS)
##### Cache (You will need to launch ElastiCache instance)
