NAME=inception
REPO_DB=/home/bguillau/data/mariadb
REPO_WP=/home/bguillau/data/wordpress

all:	${NAME}

${NAME}:	create_repos
	cp /home/bguillau/.env ./srcs/
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

clean:
	docker container stop nginx mariadb wordpress
	docker compose -f ./srcs/docker-compose.yml down

clear:
	sudo rm -rf ${REPO_DB} ${REPO_WP}
	docker system prune -af

fclean:		clean clear

re:		fclean all

create_repos:
#	[ ! -d ${REPO_DB} ] &&
	mkdir -p ${REPO_DB}
#	[ ! -d ${REPO_WP} ] &&
	mkdir -p ${REPO_WP}

.PHONY: create_repos all clean fclean re
