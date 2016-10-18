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
echo ${DOMAIN}

# change pem to crt
NEWCRT=$(echo ${LASTKEY} | sed s/pem/crt/g)

# create the crt file
$openssl x509 -outform der -in ${LASTKEY} -out ${NEWCRT}


done
