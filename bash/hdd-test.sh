#!/bin/bash
#
# Hdd Space Test
# v4.1 Joerg Neikes # added grep to % with tail - -1 alternative for df 
# v4 Joerg Neikes # changed to awk for space getting. program cut could not work with cron.
# v3 Rene Fuchs
# v2 Rene Fuchs
# v1 Rene Fuchs
#
export LANG=C
sysname=$(uname -n)
hdd=$(df | grep /dev/| awk '{print $1 }' | grep /dev/) # partitions to test

GT=85
EMAIL="YOUR-MAIL-ADDRESS@YOUR-DOMAIN.TLD"

function hddtest
{
for i in $hdd;
do
declare -i used_MB
declare -i used
# echo used=`df $i | grep ^/ | awk '{ print $5}' | sed s/\%//g` # debug
used=`df $i | grep ^/ | awk '{ print $5}' | sed s/\%//g`
# used=`df $i  | tail -1 |  grep -Eo '.{3}%.{0}' | sed s/\%//g `


if [ $used -gt $GT ]
then
echo "Caution hdd $i on $sysname is ${used}% full!" | mailx -s "hdd $i on $sysname uses ${used}%"  ${EMAIL}
fi
done
}

# test if we are root
#
#if [ $USER != root ]; then
#echo "You aren't root! We STOP! Get root or let it be!"
#exit 1
#fi

# run hdd-test
hddtest

