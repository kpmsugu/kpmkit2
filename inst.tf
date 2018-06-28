resource "aws_security_group" "tfm-sec-group" {
  name   = "suguSGP"
  vpc_id = "${aws_vpc.tform_sugu_vpc.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    name = "sugu-sgp"
  }
}

resource "aws_instance" "suguamilnx" {
  ami                         = "ami-de90a5a2"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.tfm-sec-group.id}"]
  key_name                    = "sugukeysg"
  subnet_id                   = "${aws_subnet.tform_sugu_vpc_subnet.id}"
  associate_public_ip_address = "1"

  user_data = <<-EOL
		    #!/bin/bash
		    yum install httpd -y
		    echo "This is my terraform webserver" >/var/www/html/index.html
		    service httpd start
		    EOL

  tags {
    Name = "suguamilinx"
  }
}

resource "aws_vpc" "tform_sugu_vpc" {
  cidr_block           = "20.0.0.0/16"
  enable_dns_hostnames = "1"

  tags {
    Name = "tform_sugu_vpc"
  }
}

resource "aws_subnet" "tform_sugu_vpc_subnet" {
  cidr_block              = "20.0.1.0/24"
  vpc_id                  = "${aws_vpc.tform_sugu_vpc.id}"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = "1"

  tags {
    Name = "tform_subnet_public"
  }
}

/*resource "aws_subnet" "tform_sugu_vpc_subnet1" {
	cidr_block = "20.0.2.0/24"
	vpc_id = "${aws_vpc.tform_sugu_vpc.id}"
	availability_zone = "ap-southeast-1b"
	map_public_ip_on_launch = "1"

	tags {
		Name = "tform_subnet_private"
	}
}


resource "aws_subnet" "tform_sugu_vpc_subnet2" {
	cidr_block = "20.0.3.0/24"
	vpc_id = "${aws_vpc.tform_sugu_vpc.id}"
	availability_zone = "ap-southeast-1c"

	tags {
		Name = "tform_subnet_public_1c"
	}
}
*/

resource "aws_route_table" "tform_RT" {
  vpc_id = "${aws_vpc.tform_sugu_vpc.id}"

  route {
    gateway_id = "${aws_internet_gateway.gw.id}"
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name = "tform_RT_IGW"
  }
}

resource "aws_route_table_association" "a" {
  route_table_id = "${aws_route_table.tform_RT.id}"
  subnet_id      = "${aws_subnet.tform_sugu_vpc_subnet.id}"
}

/*resource "aws_route_table" "tform_RT2" {
	vpc_id = "${aws_vpc.tform_sugu_vpc.id}"

	route {
		gateway_id = "${aws_nat_gateway.ngw.id}"
		cidr_block = "0.0.0.0/0"
	}

	tags {
		Name = "tform_RT_NAT"
	}
}*/

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.tform_sugu_vpc.id}"

  tags {
    Name = "tform_IG"
  }
}

/*
resource "aws_nat_gateway" "ngw" {
	allocation_id = "eipalloc-0e5970389ec73ed54"
	subnet_id = "${aws_subnet.tform_sugu_vpc_subnet1.id}"

	tags {
		Name = "tform_NGW"
	}
}
*/

