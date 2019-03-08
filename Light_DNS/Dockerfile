# Using Ubuntu as the base image
FROM ubuntu:latest
MAINTAINER hlpr98/generic_cache


# Setting environment variables
#
ENV VERSION=1 \
    DNS_DOMAINS_DIR="/dns_domains"

# copying the scripts from "Context" to "Workdir"
COPY scripts /scripts

# some important RUN commands
RUN chmod 755 /scripts/*			        ;\
    apt-get update                          ;\
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


# Defining Volumes to be mounted
VOLUME [ "/dns_domains" ]

# Expose port 53 of the container
EXPOSE 53

# Set an entry-point Workdir
WORKDIR /scripts

# Setting a command to execute on start-up
CMD [ "bash" ]

