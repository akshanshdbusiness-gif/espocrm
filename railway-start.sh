#!/bin/bash
set -e

APP_DIR=/var/www/html

# If not installed (config missing)
if [ ! -f "$APP_DIR/data/config.php" ]; then
    echo "First run: copying EspoCRM files into volume..."

    cp -r /usr/src/espo/* $APP_DIR/

    chown -R www-data:www-data $APP_DIR
    chmod -R 775 $APP_DIR
fi

echo "Starting Apache..."
apache2-foreground