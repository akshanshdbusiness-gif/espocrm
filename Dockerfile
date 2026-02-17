FROM php:8.3-apache

# -----------------------------
# System dependencies
# -----------------------------
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------
# PHP extensions (required by EspoCRM)
# -----------------------------
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    gd \
    zip \
    intl \
    opcache

# -----------------------------
# Apache configuration
# -----------------------------
RUN a2enmod rewrite headers expires

# Fix: More than one MPM loaded
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork

# Railway requires dynamic port
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# -----------------------------
# Copy application
# -----------------------------
COPY . /var/www/html/

# -----------------------------
# EspoCRM permissions FIX
# -----------------------------
RUN mkdir -p \
    /var/www/html/data/cache \
    /var/www/html/data/upload \
    /var/www/html/data/logs \
    /var/www/html/custom

RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 775 {} \; \
    && find /var/www/html -type f -exec chmod 664 {} \;

# -----------------------------
# Start Apache
# -----------------------------
CMD ["apache2-foreground"]
