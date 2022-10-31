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
