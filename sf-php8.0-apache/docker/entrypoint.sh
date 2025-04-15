#!/bin/bash

# Inicia cron
service cron start

# Lanza Apache en primer plano (mantiene vivo el contenedor)
exec apache2-foreground
