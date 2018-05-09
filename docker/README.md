## Docker

Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package

### Docker Compose

Compose is a tool for defining and running multi-container Docker applications.

We have defined `docker-compose.yml` file to create Containers from `nginx`, `php` and `mariadb` images.

**docker-compose.yml** contains three services -

1. **drupaldb** : It will create container name `drupaldb` using `mariadb` image and import the dump in the `drupal/db-dump` dir to the database.

2. **drupal** : It will create container name `drupal` using `php:7.2-fpm` image and mount `/var/www/html` directory to `/var/www/html` in container.

3. **nginx** : It will create container name `nginx` using `nginx:stable-alpine` image.

```
docker-compose up -d
```
will create three containers and you can anytime start and stop your container using-


```
docker-compose stop <container-name>
```

```
docker-compose start <container-name>
```

**Note** : You can configure your docker-compose file as per your requirements.

## php-nginx-composer

This is an image to build a single container for nginx, php7.2-fpm and composer. You can pull its image directly form [Docker hub](https://hub.docker.com/r/ankitjain28/php-nginx-composer/).