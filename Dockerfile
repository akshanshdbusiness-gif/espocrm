FROM php:8.3-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip zip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    default-mysql-client

# PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql mysqli gd zip intl

RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . /var/www/html

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Add runtime entrypoint fix
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Railway port
RUN sed -ri -e 's!80!${PORT}!g' /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
