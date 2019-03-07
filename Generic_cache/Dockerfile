# Using Ubuntu with NGINX installed as the base image
FROM hlpr98/ubuntu-nginx:latest
MAINTAINER hlpr98/generic_cache


# Setting environment variables
#
# Here cache-mem-size for hashes = 512 MB
#      max-size-on-disk for cache = 20 GB
#      max-age-of-cache = 30 days
#      used upstream DNS = 10.9.0.100 (which is of NITK like 10.9.0.10 and 10.20.1.21. Can't be changed to 8.8.8.8.4.4 or 8.8.8.8, it gives http_502)
#      num-of-nginx-worker-processes used = 16 (this the standard value, may be increased if sufficient resources are available)
ENV VERSION=1 \
    WEBUSER=www-data \
    CACHE_MEM_SIZE=512m \
    CACHE_MAX_AGE=30d \
    CACHE_DISK_SIZE=20480m \
    UPSTREAM_DNS=10.9.0.100 \
    NUM_WORKER_PROCESSES=16


# copying the config files from "Context" to "Workdir"
COPY Nginx_related/ /

# some important RUN commands
RUN rm /etc/nginx/sites-enabled/*           ; \
    chmod 754 /var/log/tallylog             ; \
    chmod 755 /scripts/*			        ;\
    id -u ${WEBUSER} &> /dev/null || adduser --system --home /var/www/ --no-create-home --shell /bin/false --group --disabled-login ${WEBUSER} ;\
    mkdir -m 755 -p /data/cache             ;\
    mkdir -m 755 -p /data/logs              ;\
    mkdir -m 755 -p /tmp/nginx/		        ;\
    mkdir -p /etc/nginx/sites-enabled	    ;\
    chown -R ${WEBUSER}:${WEBUSER} /data/	;\
    ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default

# Defining Volumes to be mounted
VOLUME [ "/data/cache", "/data/logs", "/var/www" ]

# Expose port 80 of the container
EXPOSE 80

# Set an entry-point Workdir
WORKDIR /scripts

# Setting a command to execute on start-up
CMD [ "./entrypoint.sh" ]

