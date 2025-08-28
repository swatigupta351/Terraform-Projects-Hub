#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx

##echo "<h1>Hello I am Swati Gupta, Welcome to All!</h1>" > /var/www/html/index.html
##echo "<a href='resume.pdf'>Do you want to see my resume ? Please Click here to see my Resume</a>" >> /var/www/html/index.html
echo "<h1> Hi This is Swati Gupta </h1>" > /var/www/html/index.html


              
