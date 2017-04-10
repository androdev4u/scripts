#!/bin/bash
# letsencrypt renewal file by Joerg Neikes aixtema GmbH
# installed certbot
# GPL2 version 0.2 23.06.2016
# cryptfile to test

DOMAIN="domain.tdl"
LETSENCRYPTDIR="/etc/letsencrypt"
KEYDIR="${LETSENCRYPTDIR}/archive/${DOMAIN}"
LASTKEY=$(ls -t ${KEYDIR}/cert*.pem| head -1)

# check if cratedate is older than 88 days
seeifolder=$(find ${LASTKEY} -mtime +59)

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

# not on all installs available:
# letsencrypt-auto renew --force-renewal

certbot renew --force-renewal

#APACHEDIR="/etc/apache2/vhosts.d"
#HTTPSCONFIG="$(ls ${APACHEDIR}/https-*.conf)"
#for i in ${HTTPSCONFIG}
#do 
#SERVERNAMES=$(grep Server ${i} | awk '{ print "-d " $2 }' | xargs echo -n)
#letsencrypt --redirect --rsa-key-size 4096 certonly --server http://acme-v01.api.letsencrypt.org/directory ${SERVERNAMES}
#sleep 2
#done 

/etc/init.d/apache2 start
fi

