## Docker

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package

**Note** : I have added two docker-compose files in `docker` dir under respective folders named `php` and `php-nginx-composer`.

## php-nginx-composer

This is a Dockerfile/image to build a container for nginx, php7.2-fpm and composer. You can pull its image directly form [Docker hub](https://hub.docker.com/r/ankitjain28/php-nginx-composer/) or you can build its image from its `Dockerfile` present in the directory.

## php

This is a Dockerfile/image to build a container from [php:7.2-fpm](https://hub.docker.com/_/php/) image pulled and installed composer on that image.

Here you can add your custom services like nginx or apache by pulling images directly from Docker hub as per your requirements, I have added nginx setting which you can change from `docker-compose` file.

**Note** : I am using `php-nginx-composer` as my default configuration.