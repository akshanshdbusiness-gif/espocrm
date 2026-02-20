#!/bin/bash
set -e

APP_DIR=/var/www/html

echo "Fixing Apache MPM..."
rm -f /etc/apache2/mods-enabled/mpm_event.* || true
rm -f /etc/apache2/mods-enabled/mpm_worker.* || true
a2enmod mpm_prefork rewrite headers expires >/dev/null 2>&1

# Railway dynamic port fix
echo "Configuring Apache to use Railway PORT: $PORT"
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-enabled/000-default.conf

# silence apache warning
echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername >/dev/null 2>&1

# install once
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