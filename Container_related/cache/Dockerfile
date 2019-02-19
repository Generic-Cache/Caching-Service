# Using Ubuntu with NGINX installed as the base image
FROM hlpr98/ubuntu-nginx:latest
MAINTAINER hlpr98/generic_cache


# Setting environment variables
#
# Here cache-mem-size for hashes = 512 MB
#      max-size-on-disk for cache = 20 GB
#      max-age-of-cache = 30 days
#      used upstream DNS = 10.9.0.100 (which is of NITK. Can be changed to 8.8.8.8.4.4 or any others)
#      num-of-nginx-worker-processes used = 16 (this the standard value, may be increased if sufficient resources are available)
ENV VERSION=1 \
    WEBUSER=www-data \
    CACHE_MEM_SIZE=512m \
    CACHE_MAX_AGE=30d \
    CACHE_DISK_SIZE=20480m \
    UPSTREAM_DNS=10.9.0.100 \
    NUM_WORKER_PROCESSES=16


# copying the config files form "Context" to "Wordir"
COPY Nginx_related/

# some important RUN commands -- to be updated after Nginx_related is completed
# RUN 
#     id -u ${WEBUSER} &> /dev/null || adduser --system --home /var/www/ --no-create-home --shell /bin/false --group --disabled-login ${WEBUSER} ;\
#     mkdir -p 755 /data/cache ;\
#     mkdir -p 755 /data/logs ;\
#     chown -R ${WEBUSER}:${WEBUSER} /data/	;\

# Defining Volumes to be mounted
VOLUME [ "/data/cache", "/data/logs" ]

# Expose port 80 of the container
EXPOSE 80

# Set an entry-point Workdir
# WORKDIR /root


