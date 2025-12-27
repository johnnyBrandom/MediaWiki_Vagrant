#!/bin/bash

DBHOST=localhost
#DBNAME=mydb
#DBUSER=myuser
#DBPASSWD=password
DBNAME=mjfrog
DBUSER=mjf_user
DBPASSWD=password

apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

apt-get -y install mysql-server

CMD="mysql -uroot -p$DBPASSWD -e"

$CMD "CREATE DATABASE $DBNAME;"
$CMD "CREATE USER $DBUSER@localhost IDENTIFIED BY '$DBPASSWD';"
$CMD "GRANT ALL PRIVILEGES ON $DBNAME.* TO $DBUSER@localhost WITH GRANT OPTION;"
$CMD "FLUSH PRIVILEGES;"

sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart
