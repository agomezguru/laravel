# This container is intended to be used like base common place for the Laravel PHP 
# framework currently only tested with 8.x and 11.x version.

# This Dockerfile was created 5/05/2020 for reuse the Docker build images more efficiently
# so, please don't be use directly. For more details see the comments at the end of this file. 
# Last updated: 13/07/2024 9:23 

# Use an official PHP runtime as a parent image
# Ref.: https://laravel.com/docs/8.x/deployment#server-requirements
FROM php:8.2.21-fpm

LABEL maintainer "agomezguru <agomezguru@coati.com.mx>"

# Get the last available packages and install any needed packages
# RUN apt update
RUN apt update && \
    apt install -y libpng16-16 libpng-dev git mariadb-client libicu-dev \
    libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libxslt1-dev \
    libmcrypt-dev libzip-dev libwebp-dev libwebp7 webp ghostscript \
    libmagickwand-dev --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Run docker-php-ext-install for available extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
  docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install intl soap xsl zip opcache sockets
RUN printf "\n" | pecl install imagick && docker-php-ext-enable imagick

# Install Composer
RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set your timezone here...
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime
RUN "date"

# The usage of this extension depends of database driver connection needed.
# Database driver connection to percona.
RUN docker-php-ext-install pdo_mysql

# Set rigths for read/write PDF files inside container. 
RUN rm /etc/ImageMagick-6/policy.xml
COPY policy.xml /etc/ImageMagick-6/policy.xml

WORKDIR /srv

# tag: agomezguru/laravel:11.x-php8.2.21
# Example: docker build . --tag agomezguru/laravel:11.x-php8.2.21

# If you desire use this Docker Image directly, uncomment the next line. 
# CMD php-fpm -F

# End of file
