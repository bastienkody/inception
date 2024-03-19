FROM 	alpine:3.18.6

LABEL	org.opencontainers.image.authors="bguillau@student.42.fr"

RUN 	apk update \
&&	apk upgrade \
&&	apk add --no-cache openrc \
		mariadb \
		mariadb-client

# needed for open-rc settings
VOLUME	[ "/sys/fs/cgroup" ]

# open-rc init
RUN		openrc \
&& 		touch /run/openrc/softlevel

# port
EXPOSE 	3306/tcp

# conf
COPY	./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# db+user creation script
COPY	/tools/mariadb_install_script.sh /etc/

# mariadb : setup + start + install + stops
#ENTRYPOINT	[ "./etc/mariadb_install_script.sh" ]

# on change de method (on peut rapatrier beaucoup dans le dockerfile) : 
# make repo et give ownership + rights to mysql:mysql
# rc-service mariadb setup -> make a test db + user root & mysql
# rc-service mariadb start -> make it accessible for parametring
# mysql -e COMMANDS	   -> parametrization
# ca marche quand je build le docker et que je rentre dedans

# can't use rc-service cause it directly exits and the container stops
#ENTRYPOINT		[ "rc-service", "mariadb", "restart" ]
#ENTRYPOINT		[ "mysqld", "--user=mysql" ]
