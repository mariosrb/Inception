#!/bin/bash

# Si lutilisateur existe pas on ajoute a la liste des users autorise pour vsftpd
if ! id -u "$FTP_USER" > /dev/null 2>&1 ; then
	useradd -m -d /var/www/wordpress -s /bin/bash -g www-data $FTP_USER
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
	echo "$FTP_USER" | tee -a /etc/vsftpd.userlist
fi

# On donne lacces aux fichiers
chown -R $FTP_USER:www-data /var/www/wordpress
chmod -R 775 /var/www/wordpress

echo "FTP Server started on port 21"
/usr/sbin/vsftpd /etc/vsftpd.conf
# Cette ligne demarre le serveur FTP en exec le bianirevsftps
