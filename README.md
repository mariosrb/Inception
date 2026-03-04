# Inception 

Inception is a 42 school project where you create a complete containerized infrastructure using Docker Compose. It deploys a WordPress website connected to a MariaDB database, all served via an NGINX reverse proxy with TLS encryption.

## Description

The main goal of this project is to understand and learn how to use:
- Docker and Docker Compose
- NGINX configuration as a reverse proxy with TLS (TLSv1.2/1.3)
- Multi-service architecture
- Docker volumes and networks

## The Containers

In this project, I used Docker and Docker Compose to orchestrate multiple containers. Each container runs a single service inside an isolated environment. The infrastructure is composed of 7 containers:

### 1. NGINX
- **Role:** Reverse Proxy. The server listens for incoming connections via a secure transport protocol (TLSv1.2/1.3) and routes them to the appropriate container.
- **Exposed ports:** 443
- **Communicates with:** WordPress, Adminer, Website (internal network)
- **Volume:** WordPress files (`wordpress_data`)

### 2. WordPress
- **Role:** Application server. It handles dynamic files (.php) using PHP-FPM, while static files are served through NGINX.
- **Exposed ports:** 9000 (internal only)
- **Communicates with:** MariaDB, Redis
- **Volume:** WordPress files (`wordpress_data`)

### 3. MariaDB
- **Role:** Database management system (open-source fork of MySQL) storing the website's data.
- **Exposed ports:** 3306 (internal only)
- **Communicates with:** WordPress, Adminer
- **Volume:** Database files (`mariadb_data`)

### 4. Portainer
- **Role:** Management tool and graphical UI for Docker (containers, images, volumes, networks).
- **Exposed ports:** 9000 (external)
- **Communicates with:** Docker daemon
- **Volumes:** Docker socket (`/var/run/docker.sock`), portainer_data (persistent data at /data)

### 5. Redis
- **Role:** In-memory cache. It can be used by WordPress for object caching to improve performance.
- **Exposed ports:** 6379 (internal only)
- **Communicates with:** WordPress
- **Volumes:** None

### 6. Adminer
- **Role:** Single-file PHP application for database management.
- **Exposed ports:** 8080 (internal only)
- **Communicates with:** MariaDB
- **Volumes:** None

### 7. Website
- **Role:** Node.js HTTP server. Serves a simple "host machine" static page displaying system info (hostname, OS, arch, memory).
- **Exposed ports:** 3000 (internal only)
- **Communicates with:** NGINX
- **Volumes:** None

## How they work together

<img width="1200" height="800" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/487054bd-0bd1-4231-b381-8bcc04ca99c0" />

As shown in the diagram above, the infrastructure is heavily compartmentalized to ensure security and modularity:

* **Entry Point:** The Client only interacts directly with **NGINX** (on port 443) and **Portainer** (for Docker management). 
* **Routing:** NGINX acts as the central traffic director. Depending on the request, it routes the client to the **WordPress** site, the **Adminer** database UI, or the custom Node.js **Website**.
* **Backend & Data:** The **WordPress** container is the core application. It is the only one communicating with **Redis** (for caching) and reads/writes to **MariaDB**. 
* **Persistence:** To ensure no data is lost if a container crashes or is rebuilt, isolated Docker Volumes are attached to **MariaDB** (database files), **WordPress** (website files), and **Portainer** (configuration).

## Instructions

### Requirements

- Docker >= 20.10
- Docker Compose >= 2.0
- Make

### Launching the project

1. Clone the repository: `git clone https://github.com/mariosrb/Inception`

2. Create a .env file, copy the text below into it and fill it with your credentials:

`DB_NAME = `

`DB_ROOT_PASSWORD = `

`DB_USER = `

`DB_PASSWORD = `

`DB_ADMIN_USER = `

`DB_ADMIN_PASSWORD = `

`DOMAIN_NAME = `

`SITE_TITLE = `

`DB_ADMIN_EMAIL = `

`USER_LOGIN = `

`USER_EMAIL = `

`USER_PASSWORD = `

3. Build and start the containers:

run `make all`
