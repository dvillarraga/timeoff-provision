#!/bin/bash    
#title          :Provision for TimeOff-Management Application on EC2 - Amazon Linux 2 AMI
#author         :dvillarraga
#date           :2020-08-10
#==============================================================================

install() {
### Installing Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
### Installing Packages ( Node JS )
sudo yum install -y git gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
sudo yum install -y nodejs
### Cloning and starting the project
git clone https://github.com/dvillarraga/timeoff-management-application.git
cd timeoff-management-application
npm install
npm start
}

"$@"
