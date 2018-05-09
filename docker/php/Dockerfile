FROM php:7.2-fpm

MAINTAINER Ankit Jain <ankitjain28may77@gmail.com>


RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y python-setuptools \
    curl \
    git \
    nano \
    sudo \
    unzip \
    openssh-server \
    openssl \
    supervisor \
    memcached \
    ssmtp \
    cron

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql soap mysqli mbstring zip

# Cleanup
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 80 3306 22

WORKDIR /var/www/html/drupal

