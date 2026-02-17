FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql

COPY . /var/www/html/

# FIX PERMISSIONS (required for EspoCRM)
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 775 {} \; \
    && find /var/www/html -type f -exec chmod 664 {} \;

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

EXPOSE 8080

CMD ["/usr/local/bin/railway-start.sh"]