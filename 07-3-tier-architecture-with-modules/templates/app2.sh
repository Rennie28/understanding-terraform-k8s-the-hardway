#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd 
sudo service httpd start
sudo echo '<h1> Welcome to RennieTechs you are in Application 2</h1>' | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app2
sudo echo '<!DOCTYPE html> <html> <body style="background-color-rgb(15, 223, 192):"> <h1> Welcome to RennieTechs - App-2</h1><p>Terraform Demo</p> <p>Application Version: V1</p></body><html>' | sudo tee /var/www/html/app2/index.html
sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app2/metadata.html
