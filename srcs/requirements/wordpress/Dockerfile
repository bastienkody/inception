FROM alpine:3.18.6

RUN 	apk update \
&& 	apk upgrade \
&& 	apk add --no-cache wget \
			php82 \
			php82-fpm \
			php82-mysqlnd \
			mysql-client

# wordpress to /var/www/html
RUN 	mkdir -p /var/www/html
RUN 	wget https://wordpress.org/wordpress-6.4.tar.gz -P /var/www/html \
&&	tar -xzf /var/www/html/wordpress-6.4.tar.gz -C /var/www/html \
&&	rm /var/www/html/wordpress-6.4.tar.gz

# rights for www-data
RUN	adduser -S www-data -G www-data \
&& 	chown -R www-data:www-data /var/www/* && chmod -R 755 /var/www/*

# port
EXPOSE 	9000/tcp

# php conf (will be included by main conf file /etc/php82/php-fpm.conf)
COPY 	./conf/www.conf /etc/php82/php-fpm.d/www.conf

# wp-cli for the wp creat/installation script
RUN 	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& 	chmod +x wp-cli.phar \
&& 	mv wp-cli.phar /usr/local/bin/wp

# wordpress user creation script
COPY 	./tools/wordpress_creation_script.sh ./ 
RUN 	chmod +x ./wordpress_creation_script.sh 

ENTRYPOINT [ "./wordpress_creation_script.sh" ]
