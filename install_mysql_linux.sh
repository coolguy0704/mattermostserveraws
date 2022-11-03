mysql -u root -pPassword42! <<-EOF
CREATE USER 'mmuser'@'%' IDENTIFIED BY 'Mostest42!';
CREATE DATABASE mattermost_test;
GRANT ALL PRIVILEGES ON mattermost_test.* TO 'mmuser'@'%';
EOF