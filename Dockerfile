FROM php:8.2-apache

# Install system packages required for gd & zip
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Configure GD properly
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install PHP extensions
RUN docker-php-ext-install \
    gd \
    zip \
    pdo \
    pdo_mysql \
    mysqli \
    intl \
    mbstring \
    exif \
    opcache

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . /var/www/html
