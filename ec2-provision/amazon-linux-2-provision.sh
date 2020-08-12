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
### Installing nginx proxy server
sudo amazon-linux-extras install -y nginx1
sudo mkdir /etc/nginx/ssl
sudo openssl req -new -newkey rsa:2048 -nodes -days 365 -x509 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=Denial/L=GFwYvGFSWfm4rNMg/O=Dis/CN=amazonaws.com"
sudo bash -c "cat > /etc/nginx/conf.d/timeoffapp.conf" << EOF
server {
    listen 80;
    server_name amazonaws.com;

    location / {
        proxy_set_header   X-Forwarded-For \$remote_addr;
        proxy_set_header   Host \$http_host;
        proxy_pass         http://localhost:3000;
    }
}
server {
    listen 443 ssl;
    server_name amazonaws.com;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        proxy_set_header   X-Forwarded-For \$remote_addr;
        proxy_set_header   Host \$http_host;
        proxy_pass         http://localhost:3000;
    }
}
EOF
sudo systemctl start nginx
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
