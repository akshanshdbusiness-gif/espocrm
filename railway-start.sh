#!/bin/bash
set -e

echo "Configuring Apache for Railway..."

# Fix MPM conflict
a2dismod mpm_event || true
a2dismod mpm_worker || true
a2enmod mpm_prefork
a2enmod rewrite

# Bind Apache to Railway port
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# Silence FQDN warning
echo "ServerName localhost" >> /etc/apache2/apache2.conf

echo "Fixing EspoCRM permissions..."

# Runtime writable folders (IMPORTANT FOR RAILWAY)
mkdir -p /var/www/html/data
mkdir -p /var/www/html/custom
mkdir -p /var/www/html/client/custom
mkdir -p /var/www/html/application/Espo/Modules

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html/data
chmod -R 775 /var/www/html/custom
chmod -R 775 /var/www/html/client/custom
chmod -R 775 /var/www/html/application/Espo/Modules

echo "Starting Apache on port $PORT..."
apache2-foreground
