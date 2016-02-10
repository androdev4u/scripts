#!/bin/bash
# needs https://github.com/androdev4u/simple-ducky
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# cd /usr/share/simple-ducky
java -jar encoder.jar -i payload.txt  -l de -o inject.bin
