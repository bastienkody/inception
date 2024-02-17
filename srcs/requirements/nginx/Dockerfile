FROM alpine:3.18.6

RUN apk update && apk upgrade
RUN apk add vim nginx

RUN mkdir -p /etc/nginx/ssl
RUN apk add openssl
RUN openssl req -x509 -days 2 -noenc \
	-out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=bguillau.42.fr/UID=bguillau"

RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html
RUN chmod 755 /var/www/html
RUN adduser -S www-data -G www-data
RUN chown -R www-data:www-data /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]
