FROM 	alpine:3.18.6

LABEL org.opencontainers.image.authors="bguillau@student.42.fr"

RUN 	apk update \
&& 		apk upgrade \
&& 		apk add --no-cache openrc \
			mariadb \
			mysql-client \
			mariadb-server-utils

RUN		rc-update add mariadb 

RUN		rc-service mariadb restart

# port
EXPOSE 	3306/tcp

# conf
COPY	./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# db+user creation script
COPY	/tools/mariadb_install_script.sh /etc/

RUN		./etc/mariadb_install_script.sh \
&&		rm -rf /etc/mariadb_install_script.sh

ENTRYPOINT [ "mysqld_safe" ]
