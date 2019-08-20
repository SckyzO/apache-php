FROM php:7.3-apache-buster

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    UID=1000 GID=998

EXPOSE 80
WORKDIR /app

RUN apt-get update -q --fix-missing && \
    apt-get install -qy \
    apt-utils \
    git \
    gnupg \
    iputils-ping \
    libicu-dev \
    unzip \
    libzip-dev \
    zip \
    curl \
    zlib1g-dev \
    libmcrypt-dev \
    libpng-dev \
    libcurl4 \
    libcurl4-gnutls-dev && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# PHP Extensions
RUN docker-php-ext-install -j$(nproc) opcache pdo_mysql curl mbstring gd zip
ADD conf/php.ini /usr/local/etc/php/conf.d/app.ini

# Apache
ADD errors /errors
RUN a2enmod rewrite headers
ADD conf/vhost.conf /etc/apache2/sites-available/000-default.conf
ADD conf/apache.conf /etc/apache2/conf-available/z-app.conf
RUN a2enconf z-app
ADD index.php /app/index.php
