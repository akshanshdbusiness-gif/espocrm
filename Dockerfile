FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
   libpng-dev \
   libjpeg-dev \
   libfreetype6-dev \
   libzip-dev \
   zip unzip \
   && docker-php-ext-install pdo pdo_mysql \
   && docker-php-ext-configure gd --with-freetype --with-jpeg \
   && docker-php-ext-install -j$(nproc) gd zip

WORKDIR /usr/src/espo
COPY . .

WORKDIR /var/www/html

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

EXPOSE 8080
CMD ["/usr/local/bin/railway-start.sh"]