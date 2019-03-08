#! /bin/bash

set -e;

echo -n "Enter the DNS domain you would like to change (must not have spaces) : "
read DOMAIN

if [[ "$DOMAIN" = *" "* ]]
then
    echo "The given DOMAIN contains spaces\nRetry again later."
    exit
fi

# converting to uppercase
DOMAIN=${DOMAIN^^}

# check if the DOMAIN's CACHE IP is already defined
# note: The CACHE IP for the DOMAIN is defined in a evn variable named ${!DOMAIN} (parameter indirection is used here)
if [[ "${!DOMAIN}" = "" ]]
then
    echo "The requested domain is already not defined"
    echo -n "Enter the IP address of the CACHE for this DOMAIN : "
    read $DOMAIN_IP

    # creating the file named $DOMAIN at /dns_domains to contain all the server names
    touch /dns_domains/"$DOMAIN"
    
    echo "The file named ${DOMAIN} has been created"

    # setting environment variable
    echo "${DOMAIN}=${DOMAIN_IP}" >> /etc/environment
    source /etc/environment     
    echo "The ENV ${DOMAIN}=${DOMAIN_IP} has been created\n"

else
    echo "The CACHE IP of the given DOMAIN, ${DOMAIN} is : ${!DOMAIN}"

fi

# taking input of the server name for this

echo "Enter the server names to be added (Ctrl+D to quit adding)"
while read -r line
do

    # handling the case of one line containg more than 1 server name seperated by spaces by conversion to array
    SERVER_NAMES=(${line})

    for SERVER_NAME in SERVER_NAMES
    do
        # check if that server name matches a complete line in the file
        if [ "$(grep -cFx "$SERVER_NAME" /dns_domains/${DOMAIN})" -eq 0]
            then 
                echo "${SERVER_NAME}" >> /dns_domains/${DOMAIN};
        fi
    done
done









