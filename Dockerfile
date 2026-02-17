FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    default-mysql-client \
    git \
    curl

# Install PHP extensions (REQUIRED for EspoCRM)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        mysqli \
        gd \
        zip \
        intl

# Enable Apache rewrite
RUN a2enmod rewrite

# 🔥 HARD FIX: Apache MPM crash on Railway
RUN a2dismod mpm_event || true
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load
RUN rm -f /etc/apache2/mods-enabled/mpm_event.conf
RUN a2enmod mpm_prefork

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html

# Permissions fix for EspoCRM
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 775 {} + \
    && find /var/www/html -type f -exec chmod 664 {} +

# Apache runs on Railway PORT
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_DOCUMENT_ROOT=/var/www/html

# Configure Apache for Railway dynamic port
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!80!${PORT}!g' /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

EXPOSE 8080

CMD ["apache2-foreground"]
