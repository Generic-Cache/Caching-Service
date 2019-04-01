# Using Ubuntu as the base image
FROM ubuntu:latest
MAINTAINER hlpr98/generic_cache

# Setting up the environment with a few other essential softwares
RUN apt --fix-broken install       ;\
    apt-get update                 ;\
    apt dist-upgrade               ;\
    apt-get -y install vim         ;\
    apt-get -y install curl        ;\
    apt-get -y install perl         ;\
    apt-get -y install autotools-dev \
                    cdbs \
                    debhelper \
                    dh-autoreconf \
                    dpkg-dev \
                    gettext \
                    libev-dev \
                    libpcre3-dev \
                    libudns-dev \
                    pkg-config \
                    fakeroot \
                    git;

# Clone SNI Proxy repo from Github 
RUN git clone https://github.com/dlundquist/sniproxy.git ;

# Compile and create the package
RUN cd sniproxy                         ;\
    ./autogen.sh && ./configure         ;\         
    # Install the package
    make && make install                ;

# deleting the default config files
RUN rm -f /etc/sniproxy.conf ;

RUN mkdir -m 775 -p /data/logs             ;

COPY SNI_proxy/ /

EXPOSE 443

# run sniproxy in foreground
CMD [ "sniproxy", "-f", "-c", "/etc/sniproxy.conf" ]
# CMD ["bash"]


