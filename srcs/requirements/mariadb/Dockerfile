FROM alpine:3.18.6

RUN apk update && apk upgrade
RUN apk add --no-cache openrc mysql mysql-client

# conf
COPY /conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# db+user creation script
COPY /tools/mariadb_install_script.sh /etc/
RUN ./etc/mariadb_install_script.sh && rm -rf /etc/mariadb_install_script.sh

# port
EXPOSE 3306/tcp
