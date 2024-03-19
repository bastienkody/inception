#!/bin/sh

# socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# rights
chown -R mysql:mysql /var/lib/mysql

# setup witouht rc-service --> pb de socket pour les mysql -e. Essayer avec la methode alpine EOF ?
#mysql_install_db --user=mysql

# setup via rc-service --> seems like its another mariadb (!= from mysqld_safe), and lauching rc-service mariadb start -> not daemonized, docker directly quits
# seems like rc-update add mariadb default -> shjould daemonize? after restart

# init db and user
rc-service mariadb setup
# add mariadb daemon
rc-update add mariadb default
# launch it
rc-service mariadb start
sleep 1

# db + user param
#if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "inside if statement mariadb"
	echo "create db"
	mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DB_NAME};"
	mysql -e "DROP USER 'mysql'@'localhost';"
	echo "create user"
	mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER_NAME}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
#	mysql  -e "ALTER USER 'mysql'@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
#	mysql  -e "UPDATE mysql.user SET Host='%' WHERE Host='localhost' AND User='${SQL_USER_NAME}';"
	mysql  -e "UPDATE mysql.db SET Host='%' WHERE Host='localhost' AND User='${SQL_USER_NAME}';"
	mysql  -e "GRANT ALL PRIVILEGES ON ${SQL_DB_NAME}.* TO '${SQL_USER_NAME}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
	echo "alter root"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
	echo "flush"
	mysql -u root --password=${SQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"
#fi

#echo "rc-service stop" >> /etc/log_maria 2>&1
#rc-service mariadb stop
sleep 2

# launch daemon
rc-service mariadb restart
#mysqld_safe --user=mysql
# unknown mdrrrr : /usr/bin/mariadb-safe --datadir='/var/lib/mysql'
 
sleep 500
