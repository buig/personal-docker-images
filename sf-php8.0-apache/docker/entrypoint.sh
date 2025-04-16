#!/bin/bash

# Set timezone (a nivel de sistema y variable de entorno)
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
echo "Europe/Madrid" > /etc/timezone
export TZ=Europe/Madrid

# Inicia cron
service cron start

# Lanza Apache en primer plano (mantiene vivo el contenedor)
exec apache2-foreground
