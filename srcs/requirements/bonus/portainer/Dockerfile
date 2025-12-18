FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	wget \
	tar \
	&& rm -rf /var/lib/apt/lists/*

	# la version 2.19 ne marchait pas car incompatbile avec la nvl version docker
RUN wget https://github.com/portainer/portainer/releases/download/2.20.2/portainer-2.20.2-linux-amd64.tar.gz \
	&& tar -xvf portainer-2.20.2-linux-amd64.tar.gz \
	&& rm portainer-2.20.2-linux-amd64.tar.gz \
	&& mv portainer /usr/local/bin/

RUN mkdir -p /data

EXPOSE 9000

CMD ["/usr/local/bin/portainer/portainer"]
