# Docker PHP Apache
A Docker image for PHP apps. Works with Apache and PHP 5.6, 7.1, 7.2 and provide a Symfony variant.

* Docker image: https://hub.docker.com/r/sckyzo/apache-php

# Install with docker-compose with Traefik + SSL

This is an example run LAMP server with Traefik, with SSL, at https://dev.domain.com

```yaml
version: '3.6'
services:

################
# APACHE + PHP #
################
  httpd-php:
    image: sckyzo/apache-php:7.3
    container_name: lamp_httpd-php
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./docker/webserver/www:/app
    networks:
      - traefik_proxy
      - default
    healthcheck:
      test: ["CMD", "curl", "-f", "http://127.0.0.1:80"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 1m
    labels:
      - "traefik.enable=true"
      - "traefik.backend=dev"
      - "traefik.frontend.rule=Host:dev.${DOMAINNAME}"
      - "traefik.port=80"
      - "traefik.docker.network=traefik_proxy"
      - "traefik.frontend.headers.SSLRedirect=true"
      - "traefik.frontend.headers.STSSeconds=315360000"
      - "traefik.frontend.headers.browserXSSFilter=true"
      - "traefik.frontend.headers.contentTypeNosniff=true"
      - "traefik.frontend.headers.forceSTSHeader=true"
      - "traefik.frontend.headers.SSLHost=${DOMAINNAME}"
      - "traefik.frontend.headers.STSIncludeSubdomains=true"
      - "traefik.frontend.headers.STSPreload=true"
      - "traefik.frontend.headers.frameDeny=true"
      - "traefik.frontend.headers.customFrameOptionsValue=SAMEORIGIN"

###########
# MARIADB #
###########
  lamp_mariadb:
    container_name: lamp_mariadb
    image: mariadb:10
    restart: unless-stopped
    volumes:
      - ./docker/webserver/mariadb:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=my_database
      - MYSQL_USER=Mr.Robot
      - MYSQL_PASSWORD=MySuperPassw0rd
      - MYSQL_ROOT_PASSWORD=MyMegaSuperPassw0rd
    networks:
      - default
#########
# Redis #
#########
  lamp_redis:
    container_name: lamp_redis
    image: redis:alpine
    restart: unless-stopped
    volumes:
      - ./docker/webserver/redis:/data
    networks:
      - default



###########
# NETWORK #
###########
networks:
  traefik_proxy:
    external:
      name: traefik_proxy
  default:
    driver: bridge
```
