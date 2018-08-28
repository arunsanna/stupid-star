#!/bin/bash
sudo yum -y update &&
sudo amazon-linux-extras install -y nginx1.12 &&
sudo service nginx start
