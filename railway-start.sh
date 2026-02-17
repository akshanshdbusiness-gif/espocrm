#!/bin/bash
set -e

echo "Fixing Apache MPM modules..."

a2dismod mpm_event || true
a2dismod mpm_worker || true
a2enmod mpm_prefork
a2enmod rewrite

echo "Starting Apache..."
apache2-foreground
