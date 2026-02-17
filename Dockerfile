FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql

RUN a2enmod rewrite

# copy project
COPY . /var/www/html/

# start apache on railway port
CMD bash -c "sed -i \"s/80/${PORT}/g\" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf && apache2-foreground"
