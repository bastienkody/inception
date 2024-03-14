#!/bin/sh

# socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# rights
chown -R mysql:mysql /var/lib/mysql

# setup
rc-service mariadb setup
rc-service mariadb start
sleep 1

# db + user param
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DB_NAME}\`;"
	mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER_NAME}\`@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DB_NAME}\`.* TO \`${SQL_USER_NAME}\`@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
	mysql --user=root --password=${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

# stops for launching form dockerfile entrypoint
rc-service mariadb stop
sleep 2

# launch daemon
mysqld --user=mysql
