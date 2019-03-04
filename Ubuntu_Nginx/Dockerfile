# Using Ubuntu as the base image
FROM ubuntu:latest
MAINTAINER hlpr98/generic_cache


# Setting up the environment with NGINX and a few other essential softwares
RUN apt-get update                 ;\
    apt-get -y install nginx       ;\
    apt-get -y install vim         ;\
    apt-get -y install curl        ;\
    apt-get -y install bc          ;
