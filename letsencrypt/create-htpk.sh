#!/bin/bash
# create HTTP Public Key Pinning keys from letsencrypt keys
# version 0.1 
# by Joerg Neikes aixtema GmbH 18.10.2016

openssl="/usr/bin/openssl"

# letsencrypt settings
LETSENCRYPTDIR="/etc/letsencrypt"
ARCHIEVEDIR="${LETSENCRYPTDIR}/archive/"

# get domains from ARCHIEVEDIR
DOMAINS=$(ls ${ARCHIEVEDIR} )

# start the search for last cert*.pem
for DOMAIN in ${DOMAINS} ; do
CERTDIR="${ARCHIEVEDIR}${DOMAIN}"
LASTKEY=$(ls ${CERTDIR}/cert*.pem| tail -1)

# change pem to crt
NEWCRT=$(echo ${LASTKEY} | sed s/pem/crt/g)

# create the crt file
$openssl x509 -outform der -in ${LASTKEY} -out ${NEWCRT}

# now used settings from https://scotthelme.co.uk/hpkp-http-public-key-pinning/
# create fingerprint of the current crt
#derpinsha256=$($openssl x509 -pubkey -inform der < ${NEWCRT} | $openssl pkey -pubin -outform der | $openssl dgst -sha256 -binary | base64)
pinsha256=$($openssl x509 -pubkey  < ${LASTKEY} | $openssl pkey -pubin -outform der | $openssl dgst -sha256 -binary | base64)

echo "Please add for ${DOMAIN}:"

echo "Header always set Public-Key-Pins \"pin-sha256=\\\"${pinsha256}\\\";  max-age=5184000; includeSubDomains\""

echo "to apache vhost."


done
