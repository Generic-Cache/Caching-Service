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
#
# 1. installing essentials for DJBDNS
# 2. installing TinyDNS and Dnscache
# 3. setting up the environment forTinyDNS and Dnscache
# TinyDNS is run on 127.0.0.1 and Dnscache on External IP. Hence, Dnscache alone interacts with the world.
# 
# Here EXTERNAL_IP is the IP address of the container and Dnscache os bound to it.
# Here LISTENING_IP_FAMILY is the family of IP address Dnscache accepts requests from (ex: 172.*.*.* represented by 172)
RUN chmod 755 /scripts/*			        ;\
    apt-get update                          ;\
    apt-get -y install apt-utils               ;\
    apt-get -y install build-essential         ;\
    apt-get -y install wget                    ;\
    apt-get -y install gzip                    ;\
    apt-get -y install tar                     ;\
    apt-get -y install net-tools               ;\
    apt-get -y install iputils-ping            ;\
    apt-get -y install iproute2                ;\
    apt-get -y install vim                     ;
  

# RUN cd /usr/local/src                       ;\
#     # Installing Daemontools
#     mkdir -p /package                       ;\
#     chmod 1755 /package                     ;\
#     cd /package                             ;\
#     wget https://cr.yp.to/daemontools/daemontools-0.76.tar.gz ;\
#     gunzip daemontools-0.76.tar             ;\
#     tar -xpf daemontools-0.76.tar           ;\
#     rm -f daemontools-0.76.tar              ;\
#     cd admin/daemontools-0.76               ;\
#     package/install                         ;\
#     # making changes to account for a bug
#     cd ./compile                              ;\
#     sed '/#define ERROR_H/a #include <errno.h>' error.h > temp.h ;\
#     cp temp.h error.h                       ;\
#     rm temp.h                               ;\
#     cd ..                                   ;\
#     package/install                         ;\
#     # Installing uscpi-tcp
#     cd /usr/local/src                       ;\
#     wget https://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz   ;\
#     gunzip ucspi-tcp-0.88.tar               ;\
#     tar -xf ucspi-tcp-0.88.tar              ;\
#     cd ucspi-tcp-0.88                       ;\
#     make                                    ;\
#     # making changes to account for a bug
#     sed '/#define ERROR_H/a #include <errno.h>' error.h > temp.h ;\
#     cp temp.h error.h                       ;\
#     rm temp.h                               ;\
#     make                                    ;\
#     make setup check                        ;\
#     # Installing DJBDNS 
#     cd /usr/local/src/                      ;\   
#     wget https://cr.yp.to/djbdns/djbdns-1.05.tar.gz ;\    
#     gunzip djbdns-1.05.tar                  ;\
#     tar -xf djbdns-1.05.tar                 ;\        
#     cd djbdns-1.05                          ;\
#     echo gcc -O2 -include /usr/include/errno.h > conf-cc ;\
#     make                                    ;\
#     make setup check                        ;\
#     # Setting up environment for TinyDNS and Dnscache
#     /usr/sbin/useradd -s /bin/false tinydns ;\
#     /usr/sbin/useradd -s /bin/false dnslog  ;\
#     /usr/sbin/useradd -s /sbin/nologin -d /dev/null dnscache;\
    # Creating a location to contain all the DNS domains.
RUN    mkdir -m 755 -p /dns_domains            ;



# Defining Volumes to be mounted
VOLUME [ "/dns_domains" ]

# Expose port 53 of the container
EXPOSE 53

# Set an entry-point Workdir
WORKDIR /scripts

# Setting a command to execute on start-up
CMD [ "bash" ]

