## Configs

From this file, You can mount files in the containers like nginx configuration file for php-fpm or php.ini file.

You can also add additions files as per your services.

Ex- In nginx service, I am mounting nginx configuration file for php7.2-fpm.

```
nginx:
    volumes:
      - ./config/nginx/default.conf:/etc/nginx/conf.d/default.conf
```