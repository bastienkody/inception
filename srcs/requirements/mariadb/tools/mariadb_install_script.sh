#!/bin/sh

# socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

chown -R mysql:mysql /var/lib/mysql

# checks if already installed
if [ ! -d "/var/lib/mysql/mysql" ]; then

	# init database -> use of rc-service mariadb setup
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

	# run init.sql (it suppress ''user and 'test' db) -> better use of mysql -e
	/usr/bin/mysqld --user=mysql --bootstrap < /tmp/init.sql
fi
