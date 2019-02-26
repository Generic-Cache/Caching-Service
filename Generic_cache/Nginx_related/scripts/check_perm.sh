#!/bin/sh
set -e

echo "Checking permissions (This may take a long time if the permissions are incorrect on large caches)..."
find /data \! -user ${WEBUSER} -exec chown ${WEBUSER}:${WEBUSER} '{}' +
echo "Permisions ok"