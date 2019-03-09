#! /bin/bash

# set -e

RPZ_DB="/etc/bind/rpz.db"
GENERIC_CACHE_DB="/etc/bind/generic_cache.db"
TEMP_DB="/etc/bind/temp.db"
GENERIC_ZONE="cache.genericcache.com."
GENERIC_EMAIL="dns.genericcache.com."


# Adding default entries to rpz.db and generic_cache.db

# Adding to rpz.db
echo "\$TTL 12H
@           IN      SOA     localhost.      admin.locahost. (
                            1       ; <serial-no>
                            3H      ; <time-to-refresh>
                            1H      ; <time-to-retry>
                            1w      ; <time-to-expire>
                            1H )    ; <minimum-TTL>
;
            IN      NS      localhost. 

" > ${RPZ_DB}

# Adding to generic_cache.db
echo "\$ORIGIN ${GENERIC_ZONE}
\$TTL 1d
@           IN      SOA     localhost.      ${GENERIC_EMAIL} (
                            $(date +%s)  ; <serial-no>
                            1w           ; <time-to-refresh>
                            900          ; <time-to-retry>
                            1w           ; <time-to-expire>
                            900 )        ; <minimum-TTL>
;
@           IN      NS      localhost.

" > ${GENERIC_CACHE_DB}


# Checking Bind config
if ! /usr/sbin/named-checkconf /etc/bind/named.conf ; then
    echo "Problem with Bind9 configuration - Bailing" >&1
    exit 1
fi

# starting BIND
# service bind9 start
/usr/sbin/named

# Adding PREVIOUS_DATE_REFERENCE to ENV
# change this to some static record like "0-0-0 0:0:0"
previous_date_reference=$(date -r ${DNS_DOMAINS_DIR} "+%Y-%m-%d %H:%M:%S")
echo "PREVIOUS_DATE_REFERENCE=\"${previous_date_reference}\"" >> /etc/environment

# starting the sync
cd /scripts
while true
do
    ./sync.sh
    sleep 1d
done
