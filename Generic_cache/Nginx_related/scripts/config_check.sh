#!/bin/sh
set -e

echo "Checking nginx config"
/usr/sbin/nginx -t

 [ $? -ne 0 ] || echo "Config check successful"