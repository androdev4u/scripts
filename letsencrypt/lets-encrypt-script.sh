#!/bin/bash

# letsencrypt renewal file by Joerg Neikes aixTeMa GmbH
# GPL3 version 0.1 10.03.2016

# cryptfile to test
LETSENCRYPTDIR="/etc/letsencrypt"
KEYDIR="${LETSENCRYPTDIR}/archive/my-domain.tld"
LASTKEY=$(ls  ${KEYDIR}/cert*.pem| tail -1)


# check if cratedate is older than 88 days
seeifolder=$(find ${LASTKEY} -mtime +88)


# begin testing of variables
if [[ -z "${seeifolder}" ]];then
   # echo "variable seeifolder is not set" # debug 
DaysOver="0"
fi
if [ -n "${seeifolder}" ]; then
    # echo "variable seeifolder is set to a non-empty string" # debug
DaysOver="1"
fi

# create new certificate
if [ ${DaysOver} == "1" ];
then
# echo "new ssl cryptfile needed" # debug

/etc/init.d/apache2 stop
sleep 2
SERVERNAMES=$(grep Server /etc/apache2/vhosts.d/my-domain.tld.conf | awk '{ print "-d " $2 }' | xargs echo -n)
letsencrypt --redirect --rsa-key-size 4096 certonly  --server https://acme-v01.api.letsencrypt.org/directory $SERVERNAMES
sleep 2
/etc/init.d/apache2 start

fi

