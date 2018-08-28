#!/bin/bash
sudo apt-get udpate &&
sudo apt-get install -y nginx &&
echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections && 
echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections &&
sudo apt-get -y install mysql-server-5.6


