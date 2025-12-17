FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
