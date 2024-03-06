rc-service mariadb setup
rc-service mariadb start

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
