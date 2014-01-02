#!/bin/bash

# Upgrade base
apt-get -y update > /dev/null 2>&1
apt-get -y upgrade > /dev/null 2>&1

# Install required packages
apt-get -y install php5 php5-curl php5-ldap php-apc php5-xdebug php5-memcached php5-memcache php5-mysql memcached libapache2-mod-rpaf nfs-common git unzip nginx ssh > /dev/null 2>&1
a2enmod expires headers rewrite rpaf

# Stop apache2 and nginx and backup base configs
service nginx stop
service apache2 stop
mv /etc/nginx /etc/nginx.bak
mv /etc/apache2 /etc/apache2.bak
mv /etc/php5 /etc/php5.bak

# Grab our curated configs for apache2, nginx, and php5
git clone http://lldev:lldev@git.luxurylink.com/scm/ldc/apache2.git /etc/apache2
git clone http://lldev:lldev@git.luxurylink.com/scm/ldc/nginx.git /etc/nginx
git clone http://lldev:lldev@git.luxurylink.com/scm/ldc/php5.git /etc/php5

# Symlink docroots
ln -s /vagrant/luxurylink /var/www/luxurylink
ln -s /vagrant/appshared /var/www/appshared
ln -s /vagrant/toolbox /var/www/toolbox
ln -s /vagrant/vacationist /var/www/vacationist

# Start services
service apache2 start
service nginx start

# NFS Mount images
echo "images:/var/www/images       /mnt/images     nfs     rsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab
mkdir /mnt/images
mount /mnt/images

# Host entries
echo "127.0.1.1 lldev.luxurylink.com" >> /etc/hosts
echo "127.0.1.1 dev-vacationist.luxurylink.com" >> /etc/hosts
echo "127.0.1.1 dev-toolbox.luxurylink.com" >> /etc/hosts
echo "127.0.1.1 dev.api.luxurylink.com" >> /etc/hosts

### Application setup

# Luxury Link
ln -s /var/www/luxurylink/app/config/ConfigLL-DEV.php /var/www/luxurylink/app/config/ConfigLL.php
ln -s /mnt/images /var/www/luxurylink/php/images
mkdir /var/www/luxurylink/smarty/cache
chmod 777 /var/www/luxurylink/smarty/cache /var/www/luxurylink/smarty/templates_c

# Toolbox
ln -s /var/www/toolbox/app/config/database.php.dev-migration /var/www/toolbox/app/config/database.php