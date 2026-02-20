#!/bin/bash
set -e

APP_DIR=/var/www/html

echo "Fixing Apache MPM..."

# hard remove conflicting MPMs (Railway-safe fix)
rm -f /etc/apache2/mods-enabled/mpm_event.load || true
rm -f /etc/apache2/mods-enabled/mpm_event.conf || true
rm -f /etc/apache2/mods-enabled/mpm_worker.load || true
rm -f /etc/apache2/mods-enabled/mpm_worker.conf || true

# ensure prefork exists
a2enmod mpm_prefork >/dev/null 2>&1 || true
a2enmod rewrite headers expires >/dev/null 2>&1 || true

# Install app only once
if [ ! -f "$APP_DIR/data/config.php" ]; then
    echo "First run: copying EspoCRM files into volume..."
    cp -r /usr/src/espo/. $APP_DIR/
    chown -R www-data:www-data $APP_DIR
    chmod -R 775 $APP_DIR
else
    echo "Existing installation detected"
fi

echo "Starting Apache..."
exec apache2-foreground