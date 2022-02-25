# ====================================================================================
#   Thanks to Daniel Ribeiro for his work (https://github.com/drgomesp/symfony-docker)
#   And of course to Chema (https://github.com/jmsv23/docker-drupal)
# ====================================================================================

# This container is intended to be used like base common place for the Laravel PHP 
# framework currently only tested with 8.x version.

# This Dockerfile was created 5/05/2020 for reuse the Docker build images more efficiently
# so, please don't be use directly. For more details see the comments at the end of this file. 
# Last updated: 25/02/2022 14:19 

# Use an official PHP runtime as a parent image
FROM php:7.4.28-fpm

LABEL maintainer "Alejandro G. Lagunas <alagunas@coati.com.mx>"

# Get the last available packages
RUN apt update

# Install any needed packages
RUN apt install -y libpng16-16
RUN apt install -y libpng-dev
RUN apt install -y git
RUN apt install -y mariadb-client
RUN apt install -y libicu-dev
RUN apt install -y libfreetype6-dev
RUN apt install -y libjpeg62-turbo-dev
RUN apt install -y libxml2-dev
RUN apt install -y libxslt1-dev
RUN apt install -y libmcrypt-dev
RUN apt install -y libzip-dev

# Run docker-php-ext-install for available extensions
RUN docker-php-ext-configure gd --with-freetype \
  --with-jpeg && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install intl
RUN docker-php-ext-install soap
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install sockets