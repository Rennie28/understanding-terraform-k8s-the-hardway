#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd 
sudo service httpd start
sudo echo '<h1> Welcome to RennieTechs you are in Application 1</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
sudo echo '<!DOCTYPE html> <html> <body style="background-color-rgb(250, 210, 210):"> <h1> Welcome to RennieTechs - App-1</h1><p>Terraform Demo</p> <p>Application Version: V1</p></body><html>' | sudo tee /var/www/html/app1/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html