# ====================================================================================
#   Thanks to Daniel Ribeiro for his work (https://github.com/drgomesp/symfony-docker)
#   And of course to Chema (https://github.com/jmsv23/docker-drupal)
# ====================================================================================

# This container is intended to be used like base common place for the Laravel PHP 
# framework currently only tested with 8.x version.

# This Dockerfile was created 5/05/2020 for reuse the Docker build images more efficiently
# so, please don't be use directly. For more details see the comments at the end of this file. 
# Last updated: 24/06/2022 15:02 

# Use an official PHP runtime as a parent image
#Ref.: https://laravel.com/docs/8.x/deployment#server-requirements
FROM php:7.4.30-fpm

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
RUN apt install -y libwebp-dev
RUN apt install -y libwebp6
RUN apt install -y webp
RUN apt install -y ghostscript
# RUN apt install -y imagemagick
RUN apt install -y libmagickwand-dev --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Run docker-php-ext-install for available extensions
RUN docker-php-ext-configure gd --with-freetype \
  --with-jpeg --with-webp && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install intl
RUN docker-php-ext-install soap
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install sockets
RUN printf "\n" | pecl install imagick && docker-php-ext-enable imagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set your timezone here...
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime
RUN "date"

# The usage of this extension depends of database driver connection needed.
# Database driver connection to percona.
RUN docker-php-ext-install pdo_mysql

# Set rigths for read/write PDF files inside container. 
RUN rm /etc/ImageMagick-6/policy.xml
COPY policy.xml /etc/ImageMagick-6/policy.xml

WORKDIR /srv

# tag: agomezguru/laravel:8.x-php7.4.x
# Example: docker build . --tag agomezguru/laravel:8.x-php7.4.x

# If you desire use this Docker Image directly, uncomment the next line. 
# CMD php-fpm -F

# End of file
