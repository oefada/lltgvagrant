#!/bin/bash

# Upgrade base
# apt-get -y update
# apt-get -y upgrade

# Install required packages
# apt-get -y install php5 php5-curl php5-ldap php-apc php5-xdebug php5-memcached php5-memcache php5-mysql memcached libapache2-mod-rpaf nfs-common git unzip nginx ssh puppet
# a2enmod expires headers rewrite rpaf

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
    # virtualbox
    sharedDirectory="/vagrant"
fi

ln -s $sharedDirectory/luxurylink /var/www/luxurylink
ln -s $sharedDirectory/appshared /var/www/appshared
ln -s $sharedDirectory/toolbox /var/www/toolbox
ln -s $sharedDirectory/vacationist /var/www/vacationist
ln -s $sharedDirectory/api.luxurylink.com /var/www/api.luxurylink.com

# Start services
service apache2 start
service nginx start

# NFS Mount images
echo "images:/var/www/images /mnt/images nfs rsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab
mkdir /mnt/images
mount /mnt/images