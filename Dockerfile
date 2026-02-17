FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip git \
    && docker-php-ext-install pdo pdo_mysql

# Copy app
COPY . /var/www/html/

# Add startup script
COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

CMD ["/usr/local/bin/railway-start.sh"]
