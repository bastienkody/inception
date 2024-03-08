# create the repo for socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql
fi
# set up mariadb ; seems like it creates db and 2 users
#rc-service mariadb setup

# launch mariadb server
rc-service mariadb restart

SQL_DB_NAME=db
SQL_USER_NAME=mysql
SQL_USER_PASSWORD=yo
SQL_ROOT_PASSWORD=yop

mysql -u mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DB_NAME}\`;"
mysql -u mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER_NAME}\`@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
mysql -u mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DB_NAME}\`.* TO \`${SQL_USER_NAME}\`@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"

mysql -u mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -u mysql -e "FLUSH PRIVILEGES;"

