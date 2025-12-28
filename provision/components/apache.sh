#!/bin/bash

apt-get update
apt-get install -y apache2

# Copy the vhost config file
cp /var/www/provision/config/apache/vhosts/mediawiki.dev.conf /etc/apache2/sites-available/mediawiki.dev.conf

# Disable the default vhost file
a2dissite 000-default

# Enable our custom vhost file
a2ensite mediawiki.dev.conf

# enable rewrite module
sudo a2enmod rewrite

# enable headers module
sudo a2enmod headers

# Restart for the changes to take effect
service apache2 restart
