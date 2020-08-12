#!/bin/bash    
#title          :Provision for TimeOff-Management Application on EC2 - Amazon Linux 2 AMI
#author         :dvillarraga
#date           :2020-08-10
#==============================================================================

install() {
### Installing Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
### Installing Packages
sudo yum install -y git gcc-c++ make ruby wget
# Installing CodeDeploy Agent
cd /home/ec2-user
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
# Installing Node
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y nodejs
### Cloning and starting the project
cd /home/ec2-user
git clone https://github.com/dvillarraga/timeoff-management-application.git
cd timeoff-management-application
npm install
sudo npm install pm2 -g
sudo pm2 --name TimeOffApplication start npm -- start
}

"$@"
