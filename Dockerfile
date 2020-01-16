FROM composer:1.9.1 as composer

FROM php:7.4-fpm-alpine as base_php

RUN apk add --update --no-cache acl=2.2.53-r0 \
  autoconf=2.69-r2 \
  dpkg-dev=1.19.7-r1 \
  dpkg=1.19.7-r1 \
  file=5.37-r1 \
  g++=9.2.0-r3 \
  gcc=9.2.0-r3 \
  icu-dev=64.2-r0 \
  libc-dev=0.7.2-r0 \
  make=4.2.1-r2 \
  pkgconf=1.6.3-r0 \
  postgresql-dev=12.1-r0 \
  re2c=1.3-r0
RUN docker-php-ext-install intl pdo pdo_pgsql pgsql

COPY .docker/php/entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /srv/api

#ENTRYPOINT ["docker-entrypoint"]
#CMD ["php-fpm"]

FROM base_php as php_dev

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN pecl install xdebug && \
  docker-php-ext-enable xdebug
COPY .docker/php/conf.d/xdebug.ini "$PHP_INI_DIR/conf.d/"

FROM nginx:1.17.6-alpine as base_nginx

COPY .docker/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /srv/api/public
