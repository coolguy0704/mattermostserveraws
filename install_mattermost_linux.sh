#!/bin/bash
rm /opt/mattermost
wget https://releases.mattermost.com/5.19.0/mattermost-5.19.0-linux-amd64.tar.gz
tar -xvzf mattermost*.gz
sudo mv mattermost /opt
mkdir /opt/mattermost/data
sudo useradd --system --user-group mattermost
sed "s/localhost:3306/$1:3306/" /opt/mattermost/config/config.json > config.json
mv config.json /opt/mattermost/config/config.json
rm -f config.json
sed "s/mmuser:mostest/mmuser:Mostest42!/" /opt/mattermost/config/config.json > config.json
mv config.json /opt/mattermost/config/config.json