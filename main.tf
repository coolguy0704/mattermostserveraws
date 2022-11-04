resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)

}

resource "aws_instance" "mattermost-db-server" {
  ami                    = var.AMI_ID
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = aws_subnet.mattermost-private-subnet-1.id
  vpc_security_group_ids = ["${aws_security_group.sg_mattermost-db-server.id}"]
  key_name               = aws_key_pair.aws-key.key_name

  provisioner "file" {
    source      = "install_mysql_linux.sh"
    destination = "install_mysql_linux.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "wget http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm",
      "sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022",
      "sudo yum localinstall mysql57-community-release-el7-9.noarch.rpm -y",
      "sudo yum install mysql-community-server -y",
      "sudo systemctl start mysqld.service",
      "sudo systemctl enable mysqld.service",
      "mysql -uroot -p`sudo grep 'temporary password' /var/log/mysqld.log | rev | cut -d\" \" -f1 | rev | tr -d \".\"` --connect-expired-password -e \"alter user root@localhost identified by 'Password42!';flush privileges;\"",
      "sudo yum install dos2unix -y",
      "sudo dos2unix install_mysql_linux.sh",
      "chmod 777 install_mysql_linux.sh",
      "sudo ./install_mysql_linux.sh",
      "rm -rf install_mysql_linux.sh"
    ]
  }

  connection {
    type                = "ssh"
    user                = "ec2-user"
    host                = self.private_ip
    private_key         = file(var.PRIVATE_KEY_PATH)
    bastion_host        = aws_instance.mattermost-app-server.public_ip
    bastion_user        = "ec2-user"
    bastion_private_key = file(var.PRIVATE_KEY_PATH)

  }

  tags = {
    "Name" = "mattermost-db-server"
  }

}

resource "aws_instance" "mattermost-app-server" {
  ami                    = var.AMI_ID
  instance_type          = var.INSTANCE_TYPE
  subnet_id              = aws_subnet.mattermost-public-subnet-1.id
  vpc_security_group_ids = ["${aws_security_group.sg_mattermost-app-server.id}"]
  key_name               = aws_key_pair.aws-key.key_name

  provisioner "file" {
    source      = var.PRIVATE_KEY_PATH
    destination = "/home/ec2-user/key.pem"
  }

  provisioner "file" {
    source      = "install_mattermost_linux.sh"
    destination = "install_mattermost_linux.sh"

  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file(var.PRIVATE_KEY_PATH)
  }

  tags = {
    "Name" = "mattermost-app-server"
  }

}

resource "null_resource" "app-server-remote-exec" {
  connection {
    type = "ssh"
    user = "ec2-user"
    host = "${aws_instance.mattermost-app-server.public_ip}"
    private_key = file(var.PRIVATE_KEY_PATH)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install dos2unix -y",
      "sudo dos2unix install_mattermost_linux.sh",
      "sudo chmod 700 install_mattermost_linux.sh",
      "sudo ./install_mattermost_linux.sh ${aws_instance.mattermost-db-server.private_ip}",
      "sudo chown -R mattermost:mattermost /opt/mattermost",
      "sudo chmod -R g+w /opt/mattermost",
      "cd /opt/mattermost",
      "nohup sudo -u mattermost ./bin/mattermost &",
      "sleep 1"
    ]
    
  }

}