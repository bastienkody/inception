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
#if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "inside if statement mariadb" > /etc/log_maria
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DB_NAME}\`;" &> /etc/log_maria
#	mysql -e "DROP USER ‘mysql’@’localhost’;" &> /etc/log_maria
	mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER_NAME}\`@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';" &> /etc/log_maria
	mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DB_NAME}\`.* TO \`${SQL_USER_NAME}\`@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';" &> /etc/log_maria
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" &> /etc/log_maria
	mysql -e "FLUSH PRIVILEGES;" &> /etc/log_maria
#fi

# stops for launching form dockerfile entrypoint
rc-service mariadb stop
sleep 2

# launch daemon
mysqld --user=mysql
