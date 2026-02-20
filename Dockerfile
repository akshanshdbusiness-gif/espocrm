FROM php:8.3-apache

# install deps
RUN apt-get update && apt-get install -y \
   libpng-dev \
   libjpeg-dev \
   libfreetype6-dev \
   libzip-dev \
   zip unzip \
   && docker-php-ext-install pdo pdo_mysql \
   && docker-php-ext-configure gd --with-freetype --with-jpeg \
   && docker-php-ext-install -j$(nproc) gd zip

# store source in image safe location
WORKDIR /usr/src/espo
COPY . .

# runtime dir
WORKDIR /var/www/html

COPY railway-start.sh /usr/local/bin/railway-start.sh
RUN chmod +x /usr/local/bin/railway-start.sh

EXPOSE 8080
CMD ["/usr/local/bin/railway-start.sh"]