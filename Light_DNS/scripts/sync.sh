#! /bin/bash

set -e;

cd ${DNS_DOMAINS_DIR}

DIRECTORY="."
TINYDNS_ROOT=/etc/tinydns/root/

# change this with some static record like "0-0-0 0:0:0"
previous_date_reference=$(date -r . "+%Y-%m-%d %H:%M:%S")

while true
do
    # check if directory is empty
    if [[ "$(ls $DIRECTORY)" = "" ]]
    then 
        # modify the previous_date_reference to current datetime
        previous_date_reference=$(date "+%Y-%m-%d %H:%M:%S")

        # sleep for 1 day
        sleep 1d    
        
        continue
    fi

    for file in "$DIRECTORY"/*
    do
        # removing "./"
        CACHE_NAME=${file//.}
        CACHE_NAME=${CACHE_NAME///}
        # convering to uppercase
        CACHE_NAME=${CACHE_NAME^^}

        # the IP of the CACHE with name = CACHE_NAME
        CACHE_IP=${!CACHE_NAME}
        
        modified_on=$(date -r $file "+%Y-%m-%d %H:%M:%S")
        if [[ "$modified_on" > "$previous_date_reference" ]]
        then
            # check what are the domains added and sync the /tinydns/data
            while read line
            do 
                if [ "$(grep -c "$line" $TINYDNS_ROOT/data)" -eq 0]
                then 
                    $TINYDNS_ROOT/add-host $line $CACHE_IP
                fi

            done < $file
        fi
    done
    
    # modify the previous_date_reference to current datetime
    previous_date_reference=$(date "+%Y-%m-%d %H:%M:%S")

    # bulding the TinyDNS database with new entries
    TINYDNS_ROOT/make

    # sleep for 1 day
    sleep 1d
done
