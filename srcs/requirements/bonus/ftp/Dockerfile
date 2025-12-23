FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	vsftpd \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/script.sh /usr/local/bin/

RUN mkdir -p /var/run/vsftpd/empty
RUN chmod +x /usr/local/bin/script.sh

#21 -> port classique pour FTP
# 21100 21110 plage de port pour mode passif
EXPOSE 21 21100-21110

CMD ["/usr/local/bin/script.sh"]
