#! /bin/sh

cd /var/www/html/wordpress

# 	for mariadb to be ready
sleep 2

#	only if wp not configured
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
	#	dl wordpress 6.4
	wp core download --allow-root
	#	edit a wp-config.php
	wp config create --allow-root \
				--dbname=${SQL_DB_NAME} \
				--dbuser=${SQL_USER_NAME} \
				--dbpass=${SQL_USER_PASSWORD} \
				--dbhost=${SQL_HOST} \
				--url=${DOMAIN_NAME}
	#	proper wp instalaltion
	wp core install --allow-root \
				--title=${SITE_TITLE} \
				--url=${DOMAIN_NAME} \
				--admin_user=${ADMIN_USER} \
				--admin_password=${ADMIN_PASSWORD} \
				--admin_email=${ADMIN_EMAIL}
	#	user of wp that can edit blogs
	wp user create --allow-root \
				${USER_LOGIN} ${USER_MAIL} \
				--role=author \
				--user_pass=${USER_PASSWORD}
	#	set the permalink structure (links with nice titles) 
	#	leads to a problem for php-fpm to retrieve the posts/pages files -> tant pis !
	#wp rewrite structure '/%postname%/' --allow-root

fi

#	on vide le cache (dans tous les cas, ca fait pas de mal i guess?)
wp cache flush --allow-root

#	create a reboot persistent repo to save sockets files needed for phpfpm to communicate
[[ ! -d /run/php ]] && mkdir /run/php

#	needed now bc does not exist in dockefile
chown -R www-data:www-data /var/www/html/wordpress

#	restart the PHP-FPM, in foreground
/usr/sbin/php-fpm82 -F -R
