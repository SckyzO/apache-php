# Docker PHP Apache
A Docker image for PHP apps. Works with Apache and PHP 7.3 from debian buster

* Docker image: https://hub.docker.com/r/sckyzo/apache-php

# Customs errors pages

With this apache configuration, I added 3 errors pages :

Error Page 403: 

![Error 403](Screenshots/403.png =250x)

Error Page 404: 

![Error 404](Screenshots/404.png =250x)

Error Page 500: 

![Error 50x](Screenshots/500.png =250x)

# Install with docker-compose with Traefik + SSL

This is an example run LAMP server with Traefik 1.7, with SSL, at https://dev.domain.com

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
      - "traefik.frontend.rule=Host:dev.example.com"
      - "traefik.port=80"
      - "traefik.docker.network=traefik_proxy"
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
