#!/bin/bash

echo ">>> Starting MariaDB service..."
service mariadb start

sleep 5

mysql -u root -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

echo ">>> Shutting down temporary MariaDB..."
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

echo ">>> Final launch of MariaDB as PID 1..."
exec mysqld_safe
