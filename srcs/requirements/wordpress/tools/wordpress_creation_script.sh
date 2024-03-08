#! /bin/sh

cd /var/www/html/wordpress

#only if wp not installed
if ! wp core is-installed; then
	#edit a wp-config.php
	wp config create	--allow-root --dbname=${SQL_DB_NAME} \
				--dbuser=${SQL_USER_NAME} \
				--dbpass=${SQL_USER_PASSWORD} \
				--dbhost=${SQL_HOST} \
				--url=https://${DOMAIN_NAME};
	#proper wp instalaltion
	wp core install		--allow-root \
				--url=https://${DOMAIN_NAME} \
				--title=${SITE_TITLE} \
				--admin_user=${ADMIN_USER} \
				--admin_password=${ADMIN_PASSWORD} \
				--admin_email=${ADMIN_EMAIL};
	#user of wp that can edit blogs
	wp user create		--allow-root \
				${USER_LOGIN} ${USER_MAIL} \
				--role=author \
				--user_pass=${USER_PASSWORD};
	#on vide le cache
	wp cache flush --allow-root
	# set to english --> mostprob not needed
	#wp language core install en_US --activate
	# set the permalink structure (links with nice titles)
	wp rewrite structure '/%postname%/'

fi

#create a reboot persistent repo to save sockets files needed for phpfpm to communicate
[[ ! -d /run/php ]] && mkdir /run/php

# start the PHP-FPM, in foreground
/usr/sbin/php-fpm82 -F -R