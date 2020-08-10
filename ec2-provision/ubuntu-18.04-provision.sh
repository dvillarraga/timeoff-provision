#!/bin/bash    
#title          :Provision for TimeOff-Management Application on EC2 - Ubuntu 18.04 AMI
#author         :dvillarraga
#date           :2020-08-10
#==============================================================================

install() {
### Installing Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt-get update && sudo apt-get install -y language-pack-en-base
sudo apt-get install -y tzdata \
     && sudo ln -fs /usr/share/zoneinfo/America/Bogota /etc/localtime
### Installing Packages
sudo apt-get install -y git make nodejs npm python vim 
### Cloning and starting the project
git clone https://github.com/dvillarraga/timeoff-management-application.git
cd timeoff-management-application
npm install
npm start
}

"$@"
