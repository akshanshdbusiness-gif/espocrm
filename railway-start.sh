#!/bin/bash
set -e

echo "Configuring Apache for Railway..."

# Fix MPM crash
a2dismod mpm_event || true
a2dismod mpm_worker || true
a2enmod mpm_prefork
a2enmod rewrite

# Remove default listen
sed -i 's/Listen 80/Listen '"$PORT"'/g' /etc/apache2/ports.conf

# Replace virtual host port
sed -i 's/<VirtualHost \*:80>/<VirtualHost *:'"$PORT"'>/g' /etc/apache2/sites-available/000-default.conf

# Avoid FQDN warning
echo "ServerName localhost" >> /etc/apache2/apache2.conf

echo "Apache will run on port $PORT"

apache2-foreground
