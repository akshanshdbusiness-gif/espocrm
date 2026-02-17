FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql

RUN a2enmod rewrite

# Railway dynamic port support
ENV APACHE_DOCUMENT_ROOT /var/www/html

# change apache to use railway port
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

COPY . /var/www/html/
