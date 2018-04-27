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

RUN a2enmod rewrite
RUN service apache2 restart

WORKDIR /var/www/html

EXPOSE 80

RUN a2enmod rewrite
