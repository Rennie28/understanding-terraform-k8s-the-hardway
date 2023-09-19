#!bin/bash
sudo yum install docker -y
sudo service docker start
sudo useradd docker
sudo yum install git -y
# sudo passwd docker 
sudo usermod -aG docker docker
sudo chmod 777 /var/run/docker.sock
## install kubelet
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
sudo echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
sudo kubectl version --short --client
