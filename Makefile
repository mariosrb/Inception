LOGIN = mariosrb

DATA_PATH = /home/$(LOGIN)/data

DOCKER_COMPOSE = docker compose -f ./srcs/docker-compose.yml
DOCKER_COMPOSE_BONUS = docker compose -f ./srcs/docker-compose.bonus.yml

all: up

up:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@$(DOCKER_COMPOSE) up -d --build

bonus:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/portainer
	@$(DOCKER_COMPOSE_BONUS) up -d --build

down:
	@$(DOCKER_COMPOSE_BONUS) down 2>/dev/null || true
	@$(DOCKER_COMPOSE) down

clean: down
	@docker system prune -a --force

fclean: clean
	@sudo rm -rf $(DATA_PATH)
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all up down clean fclean re bonus
