# Introduction

Ubuntu-Nginx is a docker based container running NGINX on the `Ubuntu:latest` as base image.

# Usage

To use the image, perform

```shell
$ docker run -td \
  --name <constainer name> \
  --restart unless-stopped \
  hlpr98/ubuntu_nginx:latest
  
