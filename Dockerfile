FROM php:8.2-apache

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

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

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

RUN a2enmod rewrite
RUN a2dismod mpm_event && a2enmod mpm_prefork

WORKDIR /var/www/html
COPY . /var/www/html
