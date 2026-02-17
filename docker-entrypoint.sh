#!/bin/bash
set -e

echo "Fixing Apache MPM modules..."

# disable everything that causes crash
a2dismod mpm_event 2>/dev/null || true
a2dismod mpm_worker 2>/dev/null || true

# ensure prefork only
a2enmod mpm_prefork

echo "Starting Apache..."
apache2-foreground
