#!/bin/sh

#	socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#	rights
chown -R mysql:mysql /var/lib/mysql

#	init db and user
rc-service mariadb setup
#	add mariadb daemon to open rc boot (good practice)
rc-update add mariadb default
#	make service on
rc-service mariadb start

# 	db + user param 
#if db/user already installed, root would need a password so condition false

if [ $(mysql -u root -e "FLUSH PRIVILEGES;" > /dev/null 2>&1 ; echo $?) == 0 ] ; then
	#	create db
	mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DB_NAME};"
	#	get rid of default user from mariadb setup
	mysql -e "DROP USER 'mysql'@'localhost';"
	#	create a user with rights
	mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER_NAME}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
	mysql  -e "UPDATE mysql.db SET Host='%' WHERE Host='localhost' AND User='${SQL_USER_NAME}';"
	mysql  -e "GRANT ALL PRIVILEGES ON ${SQL_DB_NAME}.* TO '${SQL_USER_NAME}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
	#	make root login via passwd
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
	#	changes into account
	mysql -u root --password=${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
fi

#	launch daemon
mysqld_safe --user=mysql
#rc-service mariadb restart --> daemon but rc-service exits and so the docker
