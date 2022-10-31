resource "aws_key_pair" "aws-key" {
    key_name = "aws-key"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
  
}

resource "aws_instance" "mattermost-app-server" {
    ami = "${var.AMI_ID}"
    instance_type = "${var.INSTANCE_TYPE}"
    subnet_id = "${aws_subnet.mattermost-public-subnet-1.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_mattermost-app-server.id}"]
}