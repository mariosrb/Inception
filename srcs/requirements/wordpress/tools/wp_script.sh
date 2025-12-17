#!/bin/bash

# Arrête le script si une commande échoue
set -e

# Se placer dans le dossier du site
cd /var/www/wordpress

echo "Waiting MariaDB..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB is connected !"

# --- INSTALLATION DE WORDPRESS ---
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "WordPress is not installed. Installing now..."

    wp core download --allow-root

    wp config create \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=$SQL_HOST \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --allow-root

    wp user create \
        $USER1_LOGIN \
        $USER1_EMAIL \
        --user_pass=$USER1_PASS \
        --role=author \
        --allow-root

    echo "WordPress is installed and configured!"
else
    echo "WordPress is already installed."
fi

# --- BONUS : REDIS CACHE ---
# On le met ici pour qu'il s'installe même si WP existe déjà
echo "Configuring Redis Cache..."

# Installer et activer le plugin
wp plugin install redis-cache --activate --allow-root

# Configurer les variables de connexion (Host = nom du service docker)
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --raw --allow-root

# Activer le fichier object-cache.php
wp redis enable --allow-root

# --- DROITS D'ACCÈS ---
echo "Setting permissions..."
# On rend les fichiers à l'utilisateur de NGINX/PHP
chown -R www-data:www-data /var/www/wordpress

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
