FROM debian:bookworm

# Mise à jour et installation du serveur Redis et de l'extension PHP pour WordPress
RUN apt-get update && apt-get install -y \
    redis-server \
    php-redis \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

# Définir le port
EXPOSE 6379

# Lancer le serveur Redis. 
CMD ["redis-server", "/etc/redis/redis.conf"]
