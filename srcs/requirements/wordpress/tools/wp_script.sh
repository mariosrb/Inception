#!/bin/bash

# Arrete le script si une commande échoue
set -e

# Se placer dans le dossier du site
cd /var/www/wordpress

echo "Waiting MariaDB..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done
echo "MariaDB is connected !"

# --- Wordpress installation ---
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

# --- bonus --> redis cache que si bonus ---
# on verifie sil existe sur le reseau
if getent hosts redis > /dev/null 2>&1; then
	echo "Redis containeur found, configuring Redis Cache..."

	# Installer et activer le plugin
	wp plugin install redis-cache --activate --allow-root

	# Configurer les variables de connexion (Host = nom du service docker)
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --raw --allow-root

	# Activer le fichier object-cache.php
	wp redis enable --allow-root
else
	echo "Redis not found, skipping for mandatory"
fi

# --- droits dacces ---
echo "Setting permissions..."
# On rend les fichiers à lutilisateur de NGINX/PHP
chown -R www-data:www-data /var/www/wordpress

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
