# Using Ubuntu as the base image
FROM ubuntu:latest
MAINTAINER hlpr98/generic_cache


# Setting environment variables
#
ENV VERSION=1 \
    DNS_DOMAINS_DIR="/dns_domains" \
    INTERNAL_LAN_IP_GROUP="10.0.0.0/24"

# some important RUN commands
RUN apt-get update                          ;\
    apt-get -y install apt-utils            ;\
    apt-get -y install net-tools            ;\
    apt-get -y install iputils-ping         ;\
    apt-get -y install iproute2             ;\
    apt-get -y install vim                  ;\
    apt-get -y install dnsutils             ;

# Installing BIND-9
RUN apt-get -y install bind9                ;\
    apt-get -y install bind9utils           ;\
    apt-get -y install bind9-doc            ;

# Setting up environment suitable for further tasks
RUN rm -f /etc/bind/named.conf              ;\
    rm -f /etc/bind/named.conf.options      ;\
    rm -f /etc/bind/named.conf.local        ;\
    mkdir -m 775 -p /var/log/bind           ;

# copying the scripts from "Context" to "Workdir"
COPY scripts /scripts

# copying ./etc/ to /etc/ of the container
COPY etc/ /etc


RUN mkdir -m 755 -p /dns_domains            ;\
    chmod 755 /scripts/*			        ;

# Defining Volumes to be mounted
VOLUME [ "/dns_domains" ]

# Expose port 53 of the container
EXPOSE 53

# Set an entry-point Workdir
WORKDIR /scripts

# Setting a command to execute on start-up
CMD [ "./entrypoint.sh" ]

