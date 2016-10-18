#!/bin/bash
# create HTTP Public Key Pinning keys from letsencrypt keys
# version 0.2 
# by Joerg Neikes aixtema GmbH 18.10.2016

openssl="/usr/bin/openssl"

# Openssl Settings change to fit to your needs
COUNTRY="US"
STATE="FL"
CITY="Ocala"
ORGANISATION="Home"
MAILADDRESS="webmaster@${DOMAIN}"

#apache vhost settings
APACHEVHOSTDIR="/etc/apache2/vhosts.d/"

# letsencrypt settings
LETSENCRYPTDIR="/etc/letsencrypt"
ARCHIEVEDIR="${LETSENCRYPTDIR}/archive/"

# get domains from ARCHIEVEDIR
DOMAINS=$(ls ${ARCHIEVEDIR} )

# start the search for last cert*.pem
for DOMAIN in ${DOMAINS} ; do
CERTDIR="${ARCHIEVEDIR}${DOMAIN}"
LASTKEY=$(ls ${CERTDIR}/cert*.pem| tail -1)

# get only domain without ending
NOTDLDOMAIN=$(echo ${DOMAIN}|  cut -d"." -f1 )

# change pem to crt
NEWCRT=$(echo ${LASTKEY} | sed s/pem/crt/g)

# create the crt file
$openssl x509 -outform der -in ${LASTKEY} -out ${NEWCRT}

# now used settings from https://scotthelme.co.uk/hpkp-http-public-key-pinning/
# create fingerprint of the current crt
#derpinsha256=$($openssl x509 -pubkey -inform der < ${NEWCRT} | $openssl pkey -pubin -outform der | $openssl dgst -sha256 -binary | base64)
serverpinsha256=$($openssl x509 -pubkey  < ${LASTKEY} | $openssl pkey -pubin -outform der | $openssl dgst -sha256 -binary | base64)

echo "Creating first key for ${DOMAIN}"
# first key generation
# create frist key
$openssl  genrsa -out ${CERTDIR}/${DOMAIN}.first.key 4096 &>/dev/null
# create csr
$openssl req -new -key ${CERTDIR}/${DOMAIN}.first.key -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORGANISATION}/CN=${DOMAIN}/emailAddress=${MAILADDRESS}" -sha256 -out ${CERTDIR}/${DOMAIN}.first.csr &>/dev/null
firstpinsha256=$($openssl  req -pubkey < ${CERTDIR}/${DOMAIN}.first.csr  | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64)

echo "Creating second key for ${DOMAIN}"
# second key generation
# create second key
$openssl  genrsa -out ${CERTDIR}/${DOMAIN}.second.key 4096 &>/dev/null
# create csr
$openssl req -new -key ${CERTDIR}/${DOMAIN}.second.key -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${ORGANISATION}/CN=${DOMAIN}/emailAddress=${MAILADDRESS}" -sha256 -out ${CERTDIR}/${DOMAIN}.second.csr &>/dev/null
secondpinsha256=$($openssl  req -pubkey < ${CERTDIR}/${DOMAIN}.second.csr  | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64)


for config in $(find ${APACHEVHOSTDIR} -name "*${NOTDLDOMAIN}*.conf"); do
echo ${config}
# remove old header Public-Key-Pins
sed -i '/Header always set Public-Key-Pins/,0d' ${config}
# add new header below #Set-Public-Key-Pins
# sed  '/#Set-Public-Key-Pins/a Header always set Public-Key-Pins="hello"' ${config}
NEWHEADER="Header always set Public-Key-Pins \"pin-sha256=\\\\\"${serverpinsha256}\\\\\"; pin-sha256=\\\\\"${firstpinsha256}\\\\\"; pin-sha256=\\\\\"${secondpinsha256}\\\\\"; max-age=5184000; includeSubDomains\""

sed -i "/#Set-Public-Key-Pins/a \ \ \ \ \ \ \ \ ${NEWHEADER}" ${config}


done
done
