resource "aws_vpc" "mattermost-vpc" {
    cidr_block = "${var.VPC_CIDR}"
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    tags = {
      "Name" = "mattermost-vpc"
    }

}

resource "aws_subnet" "mattermost-public-subnet-1" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    cidr_block = "${var.VPC_PUBLIC_SUBNET_CIDR}"
    map_public_ip_on_launch = true
    availability_zone = "${var.AWS_AZ}"
    tags = {
      "Name" = "mattermost-public-subnet-1"
    }

}

resource "aws_subnet" "mattermost-private-subnet-1" {
    vpc_id = "${aws_vpc.mattermost-vpc.id}"
    cidr_block = "${var.VPC_PRIVATE_SUBNET_CIDR}"
    availability_zone = "${var.AWS_AZ}"
    tags = {
      "Name" = "mattermost-private-subnet-1"
    }

}