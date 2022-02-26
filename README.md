# Quick reference, laravel

Configured PHP 7.4 server for deploy Laravel 8.x based projects

- **Maintained by**:
[agomezguru](https://github.com/agomezguru)

- **Where to get help**:  
[Docker Official Images: php](https://hub.docker.com/_/php/)

## Supported tags and respective `Dockerfile` links

- [`8.x-php7.4.x`, `latest`](https://github.com/agomezguru/laravel)

## How to use this image

The intent of this image is always being together use with a NGINX docker container and MySQL/MariaDB/Percona database with a simple `Dockerfile` (in `/host/path/`) like this one:

```bash
cat <<EOF > docker-compose.yml
version: '3'

volumes:
  my-public:
    external: true
  my-db-data:
    external: true

services:
  web:
    image: agomezguru/nginx:laravel-8x
    ports:
      - "$outsidePort:80"
    environment:
      - HOST_NAME=myAppHostName
      - LOG_STATUS=on
      - LOG_NAME=myAppLogName
      - DEPLOYMENT_STAGE=develop
      - PHP_CONTAINER_NAME=php
    volumes:
      - ../someCode:/srv
      - my-public:/srv/public
    networks:
      - $env-network

  php:
    image: agomezguru/laravel:8.x-php7.4.x
    volumes:
      - ../someCode:/srv
      - my-public:/srv/public
      - ./php-composer.ini:/usr/local/etc/php/conf.d/custom.ini
    networks:
      - $env-network

  db:
    image: percona:5.7.35
    volumes:
      - my-db-data:/var/lib/mysql
      - ../percona/masterdb/config:/etc/mysql/conf.d
      - ../dumps:/backups-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: $envPassword
    networks:
      - $env-network

# Isolate docker containers arrays between environments.
networks:
  $env-network:
    driver: bridge
EOF
```

### Using environment variables in nginx configuration

This container image doesn't support any environment variables.

## License

View [php license information](http://www.php.net/software/) and [Composer](https://github.com/composer/composer/blob/master/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
