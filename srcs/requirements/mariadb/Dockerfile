FROM alpine:3.18.6

RUN apk update && apk upgrade
RUN apk add --no-cache openrc mysql mysql-client

COPY /conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY /tools/mariadb_install_script.sh /etc/
RUN ./etc/mariadb_install_script.sh && rm -rf /etc/mariadb_install_script.sh
