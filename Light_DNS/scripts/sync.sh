#! /bin/bash

# set -e;

cd ${DNS_DOMAINS_DIR}

DIRECTORY="."
RPZ_DB="/etc/bind/rpz.db"
GENERIC_CACHE_DB="/etc/bind/generic_cache.db"
TEMP_DB="/etc/bind/temp.db"
GENERIC_ZONE="cache.genericcache.com."
GENERIC_EMAIL="dns.genericcache.com."


# Getting the PREVIOUS_DATE_REFERENCE
previous_date_reference=$(grep -oP "(?<=PREVIOUS_DATE_REFERENCE=).*" /etc/environment)
previous_date_reference=$(eval printf %s $previous_date_reference);

# check if directory is empty
if ! [[ "$(ls $DIRECTORY)" = "" ]]
then 
    for file in "$DIRECTORY"/*
    do
        # removing "./"
        DOMAIN=${file//.}
        DOMAIN=${DOMAIN///}
        # converting to uppercase
        DOMAIN=${DOMAIN^^}

        # the IP of the CACHE with name = CACHE_NAME
        CACHE_IP=$(grep -oP "(?<=${DOMAIN}=).*" /etc/environment)
        
        modified_on=$(date -r $file "+%Y-%m-%d %H:%M:%S")
        if [[ "$modified_on" > "$previous_date_reference" ]]
        then

            # check if the servers belonging to DOMAIN have been added at least once
            # if not add it as a comment in /etc/bind/rpz.db and
            # as a "A" record in /etc/bind/generic_cache.db
            if [ "$(grep -cFx ";## ${DOMAIN,,}" ${RPZ_DB})" -eq 0 ]
            then
                echo ";## ${DOMAIN,,}" >> ${RPZ_DB}
                echo "${DOMAIN,,} IN A ${CACHE_IP}" >> ${GENERIC_CACHE_DB}
            fi

            # check what are the domains added and sync the /etc/bind/rpz.db and /etc/bind/generic_cache.db
            while read server
            do 
                if [ "$(grep -c "$server" ${RPZ_DB})" -eq 0 ]
                then 

                    # enter the new entry in the format
                    # my.hostserver.com IN CNAME mydomain.cache.generic_cache.com.;
                    sed "/;## ${DOMAIN,,}/a ${server} IN CNAME ${DOMAIN,,}.${GENERIC_ZONE}" ${RPZ_DB} > ${TEMP_DB}
                    cp ${TEMP_DB} ${RPZ_DB}

                fi

            done < $file
        fi
    done
fi

# remove temp.dp file
echo "temp" > ${TEMP_DB}
rm ${TEMP_DB}
    
# modify the previous_date_reference to current datetime
new_date_reference=$(date "+%Y-%m-%d %H:%M:%S")
sed -i "s/PREVIOUS_DATE_REFERENCE=\"${previous_date_reference}\"/PREVIOUS_DATE_REFERENCE=\"${new_date_reference}\"/" /etc/environment

# Checking Bind config
if ! /usr/sbin/named-checkconf /etc/bind/named.conf ; then
    echo "Problem with Bind9 configuration - Bailing" >&2
    exit 1
fi

# Restart BIND
# service bind9 restart
/usr/sbin/named
service bind9 stop
/usr/sbin/named