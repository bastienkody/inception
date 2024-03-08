# create the repo for socket
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# add to boot (not needed for this project I guess)
#rc-update add mariadb

# set up mariadb ; seems like it creates db and 2 users
#rc-service mariadb setup

# we call this as entrypoint in dockerfile; it calls mysqld_safe
#rc-service mariadb restart

SQL_DB_NAME=db
SQL_USER_NAME=yo
SQL_USER_PASSWORD=yo
SQL_ROOT_PASSWORD=yop

mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DB_NAME}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER_NAME}\`@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DB_NAME}\`.* TO \`${SQL_USER_NAME}\`@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';"

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
