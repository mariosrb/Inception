FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php php-mysqli wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# on telecharge adminer
RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O index.php

EXPOSE 8080

# On lance le serveur
# -S : lancer le serveur
#0.0.0.0:8080 ecouter toutes le sip sur 8080
# -t : definir le dossier racine
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
