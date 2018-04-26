FROM php:7.2 -apache

RUN apt-get update -y && apt-get install -y libpng-dev curl libcurl4-openssl-dev libapache2-mod-php

RUN docker-php-ext-install php-mysql gd curl php-mcrypt

RUN a2enmod rewrite
RUN service apache2 restart