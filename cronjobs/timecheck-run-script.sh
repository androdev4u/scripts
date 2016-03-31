#!/bin/bash
# timecheck-run-script.sh by Joerg Neikes
# version 1.0
# license GPL v2

# These settings are for Europe/Berlin and should test for a  07:00 am to 07:02 am timeslot
# The variables TIMETOUSEFROM="${HOURNEW}:00:00"and  TIMETOUSETO="${HOURNEW}:02:00" must be changed manual
# if an other slot should be used

# Beware: Do not use at 03:00:00 am ! Could make problems on summer and winter settings

# The util datetest is needed.
# It can be installed from https://github.com/hroptatyr/dateutils .
# On gentoo do an: emerge dateutils .

# datetest uses UTC so we recalc it from to Europe/Berlin to right UTC time.

# Variables for settings and testing
HOUR="7"

HOURSUMMER="2"
HOURWINTER="1"

# winter snd summer testing
TIMEZONETEST=$(date +%Z)
SUMMER="CEST"
WINTER="CET"




# See if we are in summer time
if [ $TIMEZONETEST == $SUMMER ] ;
then
# echo "We are in summer time" # debug 
HOURNEW=$((${HOUR}-${HOURSUMMER}))
# HOURNEW=$((${HOUR})) # debug
# add zero to HOURNEW
printf -v j "%02d" $HOURNEW
TIMETOUSEFROM="${HOURNEW}:00:00"
TIMETOUSETO="${HOURNEW}:02:00"



# only write to db if under TIMETOUSEFROM and over TIMETOUSETO
if dtest time --gt $TIMETOUSEFROM && dtest time --lt $TIMETOUSETO; then

   VARIABLE="set" # only to do something for the if

#   echo "TIMETOUSEFROM $TIMETOUSEFROM and TIMETOUSET $TIMETOUSETO" # debug
 else
   /home/user/bin/example-script.pl
fi

fi

# See if we are in winter time 

if [ $TIMEZONETEST == $WINTER ] ;
then
# echo "We are in winter time" # debug
HOURNEW=$(($HOUR-$HOURWINTER))
# HOURNEW=$((${HOUR})) # debug

# add zero to HOURNEW
printf -v j "%02d" $HOURNEW
TIMETOUSEFROM="${HOURNEW}:00:00"
TIMETOUSETO="${HOURNEW}:02:00"


# only write to db if under TIMETOUSEFROM and over TIMETOUSETO
if dtest time --gt $TIMETOUSEFROM && dtest time --lt $TIMETOUSETO; then

   VARIABLE="set" # only to do something for the if

#   echo "TIMETOUSEFROM $TIMETOUSEFROM and TIMETOUSET $TIMETOUSETO" # debug
else
   /home/user/bin/example-script.pl
fi

fi
