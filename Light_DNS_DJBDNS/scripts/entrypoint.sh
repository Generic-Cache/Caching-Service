#! /bin/bash

cd /usr/local/src/djbdns-1.05  

# TinyDNS initialisation

tinydns-conf tinydns dnslog /etc/tinydns 127.0.0.1
sh -cf '/command/svscanboot &'
ln -s /etc/tinydns /service 
sleep 5           
svstat /service/tinydns

# Dnscache initialisation

# EXTERNAL_IP = IP of the container.
EXTERNAL_IP=$(hostname -I)
echo EXTERNAL_IP=$EXTERNAL_IP >> /etc/environment 
source /etc/environment
dnscache-conf dnscache dnslog /etc/dnscache $EXTERNAL_IP
ln -s /etc/dnscache /service 
sleep 5           
svstat /service/*
# LISTENING_IP_FAMILY is same as the possible IP address of Docker gateways.
LISTENING_IP_FAMILY=$(ip route | grep default | cut -d " " -f 3 | cut -d "." -f 1)
touch /etc/dnscache/root/ip/$LISTENING_IP_FAMILY 


# starting the sync
cd /scripts
./sync.sh