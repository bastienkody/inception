FROM alpine:3.18.6

RUN apk update && apk upgrade
RUN apk add --no-cache wget php82 php82-fpm php82-mysqlnd mysql-client

# wordpress to /var/www/html
RUN mkdir -p /var/www/html
RUN wget https://wordpress.org/wordpress-6.4.tar.gz -P /var/www/html
RUN tar -xzf /var/www/html/wordpress-6.4.tar.gz && rm /var/www/html/wordpress-6.4.tar.gz

# rights for www-data
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# port
EXPOSE 9000/tcp

# php conf 
COPY ./tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# wp-cli for the script
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod u+x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# wordpress user creation script
COPY ./tools/wordpress_creation_script.sh ./ 
RUN chmod u+x ./wordpress_creation_script.sh && ./wordpress_creation_script.sh
