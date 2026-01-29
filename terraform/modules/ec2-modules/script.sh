#!/bin/bash

sudo apt update
sudo apt install nginx
echo "hello everyone" >  /var/www/html/index.html
sudo systemctl start nginx