resource "aws_internet_gateway" "mattermost-igw" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    tags = {
      "Name" = "mattermost-igw"
    }
  
}

resource "aws_route_table" "mattermost-public-crt" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.mattermost-igw.id}"
    }
    tags = {
      "Name" = "mattermost-public-crt"
    }
  
}

resource "aws_route_table_association" "mattermost-crt-public-subnet" {
    subnet_id = "${aws_subnet.mattermost-public-subnet-1.id}"
    route_table_id = "${aws_route_table.mattermost-public-crt.id}"
  
}

resource "aws_eip" "mattermost-eip" {
    vpc = true
    tags = {
        "Name" = "mattermost-eip"
    }
  
}
resource "aws_nat_gateway" "mattermost-nat-gw" {
    subnet_id = "${aws_subnet.mattermost-public-subnet-1.id}"
    allocation_id = "${aws_eip.mattermost-eip.id}"
    connectivity_type = "public"
    tags = {
      "Name" = "mattermost-nat-gw"
    }

}

resource "aws_route_table" "mattermost-private-crt" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.mattermost-nat-gw.id}"
    }
    tags = {
      "Name" = "mattermost-private-crt"
    }
  
}

resource "aws_route_table_association" "mattermost-crt-private-subnet" {
    subnet_id = "${aws_subnet.mattermost-private-subnet-1.id}"
    route_table_id = "${aws_route_table.mattermost-private-crt.id}"
  
}

resource "aws_security_group" "allow_tcp_icmp" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    name = "allow-tcp"
    description = "allow tcp traffic"
    dynamic "ingress" {
      for_each = "${var.SG_PORTS}"
      iterator = port
      content {
        from_port = port.value
        to_port = port.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "Name" = "allow_tcp_icmp"
    }
  
}