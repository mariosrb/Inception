FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY /tools/wp_script.sh /usr/local/bin/wp_script.sh

RUN chmod +x /usr/local/bin/wp_script.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_script.sh"]
