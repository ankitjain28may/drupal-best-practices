FROM ubuntu:16.04

MAINTAINER Ankit Jain

RUN apt-get update \
    && apt-get install -y apache2 curl zip unzip git software-properties-common supervisor \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.2-fpm php7.2-cli php7.2-mcrypt php7.2-gd php7.2-mysql \
       php7.2-imap php-memcached php7.2-mbstring php7.2-xml php7.2-curl \
       php7.2-xdebug \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

Run apt-get install -y git
RUN apt-get update

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

COPY dir.conf /etc/apache2/mods-enabled/dir.conf

EXPOSE 80

RUN systemctl restart apache2

RUN a2enmod rewrite

