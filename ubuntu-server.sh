#!/usr/bin/env bash
sudo apt-get update && sudo apt-get -y install language-pack-en-base software-properties-common python-software-properties && sudo apt upgrade -y

sudo locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8 && export LC_ALL=en_US.UTF-8

sudo add-apt-repository -y ppa:ondrej/php && sudo add-apt-repository -y ppa:ondrej/nginx
sudo systemctl stop apache2 && sudo apt-get -y remove apache2 && sudo apt -y autoremove
sudo apt-get update && sudo apt-get -y install nginx
sudo ufw allow 'Nginx HTTP'
sudo apt-get -y install mariadb-server mariadb-client
sudo mysql_secure_installation
sudo mysql -u root -p < use mysql; update user set plugin='mysql_native_password' where user='root'; flush privileges; quit;
sudo apt-get -y install php5.6 php5.6-fpm php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml
sudo sed -i '' -e 's/;cgi\.fix_pathinfo=1/cgi.fix_pathinfo=0/;' /etc/php/5.6/fpm/php.ini
sudo systemctl restart php5.6-fpm
sudo systemctl enable nginx
sudo systemctl start nginx
