FROM alpine:3.18.6

LABEL org.opencontainers.image.authors="bguillau@student.42.fr"

RUN 	apk update \
&&		apk upgrade \
&&		apk add --no-cache nginx openssl

#	ssl certificates
RUN 	mkdir -p /etc/nginx/ssl
RUN 	openssl req -x509 -noenc -days 300 \
		-out /etc/nginx/ssl/inception.crt \
		-keyout /etc/nginx/ssl/inception.key \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=bguillau.42.fr"

#	conf
RUN 	mkdir -p /var/run/nginx
COPY 	conf/nginx.conf /etc/nginx/nginx.conf

#	rigths (if not working multiple needed)
RUN 	mkdir -p /var/www/html; \
		chmod 755 /var/www/html; \
		adduser -S www-data -G www-data; \
		chown -R www-data:www-data /var/www/html

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
