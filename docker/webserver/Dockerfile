FROM php:7.2-apache

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libcurl4-openssl-dev \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libedit-dev \
    libtidy-dev \
    libxml2-dev \
    libsqlite3-dev \
    libpq-dev \
    libbz2-dev \
    gettext-base \
    locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) curl gd intl json readline tidy zip bcmath xml mbstring pdo_mysql bz2

RUN apt-get install -y git

RUN chown -R www-data:www-data /var/www/html

#setup composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

EXPOSE 80
RUN a2enmod rewrite