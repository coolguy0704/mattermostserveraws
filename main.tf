resource "aws_key_pair" "aws-key" {
    key_name = "aws-key"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
  
}

resource "aws_instance" "mattermost-db-server" {
    ami = "${var.AMI_ID}"
    instance_type = "${var.INSTANCE_TYPE}"
    subnet_id = "${aws_subnet.mattermost-private-subnet-1.id}"
    vpc_security_group_ids = [ "${aws_security_group.sg_mattermost-db-server.id}" ]
    key_name = "${aws_key_pair.aws-key.key_name}"

  
}


resource "aws_instance" "mattermost-app-server" {
    ami = "${var.AMI_ID}"
    instance_type = "${var.INSTANCE_TYPE}"
    subnet_id = "${aws_subnet.mattermost-public-subnet-1.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_mattermost-app-server.id}"]
    key_name = "${aws_key_pair.aws-key.key_name}"
    provisioner "file" {
        source = "install_mattermost.sh"
        destination = "/tmp/install_mattermost.sh"
    }
    provisioner "file" {
        source = "${var.PRIVATE_KEY_PATH}"
        destination = "/home/ec2-user/key.pem"
      
    }
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
      private_key = "${file(var.PRIVATE_KEY_PATH)}"
    }

}