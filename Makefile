NAME=inception
REPO_DB=/home/bguillau/data/mariadb
REPO_WP=/home/yatang/data/wordpress

all:	${NAME}

${NAME}:	create_repos
	docker compose -f ./srcs/docker-compose.yml build
	docker compose -f ./srcs/docker-compose.yml up -d

clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception

fclean:	clean
	rm -rf ${REPO_DB} ${REPO_WP}
	docker system prune -af

re:		fclean all

create_repos:
	[ ! -d ${REPO_DB} ] && mkdir -p ${REPO_DB}
	[ ! -d ${REPO_WP} ] && mkdir -p ${REPO_WP}

.PHONY: create_repos all clean fclean re
