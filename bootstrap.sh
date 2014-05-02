#!/bin/bash

# Add host entries
echo "127.0.0.1 localhost.localdomain localhost lldev dev-toolbox.luxurylink.com dev-luxurylink.luxurylink.com dev-vacationist.luxurylink.com dev.api.luxurylink.com" >> /etc/hosts

# Upgrade base
apt-get -y update
apt-get -y upgrade

# Install required packages
apt-get -y install curl php5 php5-curl php5-ldap php-apc php5-xdebug php5-memcached php5-memcache php5-mysql php5-tidy memcached libapache2-mod-rpaf nfs-common git unzip nginx ssh sendmail-bin
a2enmod expires headers rewrite rpaf

# Install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin -- --filename=composer

# Stop apache2 and nginx and backup base configs
service nginx stop
service apache2 stop
mv /etc/nginx /etc/nginx.bak
mv /etc/apache2 /etc/apache2.bak
mv /etc/php5 /etc/php5.bak

# Grab our curated configs for apache2, nginx, and php5
git clone http://git.luxurylink.com/scm/ldc/apache2.git /etc/apache2
git clone http://git.luxurylink.com/scm/ldc/nginx.git /etc/nginx
git clone http://git.luxurylink.com/scm/ldc/php5.git /etc/php5

# Symlink docroots
if [ -d "/media/psf/vagrant" ]
then
    # parallels
    sharedDirectory="/media/psf/vagrant"
elif [ -d "/vagrant" ]
then
    # virtualbox, vmware
    sharedDirectory="/vagrant"
fi

ln -s $sharedDirectory/luxurylink /var/www/luxurylink
ln -s $sharedDirectory/appshared /var/www/appshared
ln -s $sharedDirectory/toolbox /var/www/toolbox
ln -s $sharedDirectory/vacationist /var/www/vacationist
ln -s $sharedDirectory/api.luxurylink.com /var/www/api.luxurylink.com

# NFS Mount images
echo "images:/var/www/images /mnt/images nfs rsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab
mkdir /mnt/images
mount /mnt/images

### Setup Applications

# setup luxurylink
if [ -d "$sharedDirectory/luxurylink" ]
then
    cd $sharedDirectory/luxurylink/app/config
    ln -s ConfigLL-DEV.php ConfigLL.php
    cd $sharedDirectory/luxurylink/php/community/includes
    ln -s config.php.development config.php
    cd $sharedDirectory/luxurylink/php
    ln -s /mnt/images images
    cd $sharedDirectory
    mkdir luxurylink/smarty/cache luxurylink/smarty/templates_c
    chmod 777 luxurylink/smarty/cache luxurylink/smarty/templates_c
fi

# setup toolbox
if [ -d "$sharedDirectory/toolbox" ]
then
    cd $sharedDirectory/toolbox/app/config/
    ln -s database.dev.php database.php
    cd $sharedDirectory/toolbox/app/vendors/
    ln -s ../../../appshared .
    cd $sharedDirectory/toolbox/app/webroot/
    ln -s /mnt/images images
    cd $sharedDirectory
    chmod 777 toolbox/app/tmp
fi

# setup vcom
if [ -d "$sharedDirectory/vacationist" ]
then
    cd $sharedDirectory/vacationist/frontend/app/config
    ln -s ConfigVCOM-DEV.php ConfigVCOM.php
    cd $sharedDirectory/vacationist/frontend/public
    ln -s .DEV.htaccess .htaccess
    ln -s /mnt/images/vacationist images
    cd $sharedDirectory/vacationist/backend/public
    ln -s .DEV.htaccess .htaccess
    cd $sharedDirectory
fi

# setup api
if [ -d "$sharedDirectory/api.luxurylink.com" ]
then
    cd $sharedDirectory/api.luxurylink.com
    composer install
    chmod -R 777 app/cache app/logs
    cd $sharedDirectory/api.luxurylink.com/web
    ln -s app_dev.php app.php
fi

# Start services
service apache2 start
service nginx start
