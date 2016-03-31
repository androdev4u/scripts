#!/bin/bash
# timecheck-run-script.sh by Joerg Neikes
# version 1.1
# license GPL v2

# These settings are for Europe/Berlin and should test for a  07:00 am to 07:02 am timeslot
# The variables TIMETOUSEFROM="${HOURNEW}:00:00"and  TIMETOUSETO="${HOURNEW}:02:00" must be changed manual
# if an other slot should be used

# Beware: Do not use at 03:00:00 am ! Could make problems on summer and winter settings

# The util datetest is needed.
# It can be installed from https://github.com/hroptatyr/dateutils .
# On gentoo do an: emerge dateutils .

# Many thanks to Sebastian Freundt for the timezonefix with the dateconv command.
# It's really small now.

# Changelog for version 1.1
# Recalc of UTC to CET or CEST is not needed any more.

# Script to execute 
SCRIPT="/root/bin/temp2mysql.pl"

# Variables for settings and testing
HOUR="7"
# Plese set your timezone here
MYTIMEZONE="Europe/Berlin"
NOW_IN_MYTIMEZONE=`dateconv -z ${MYTIMEZONE} -f %T now`

# add zero to $HOUR if needed
printf -v j "%02d" $HOUR
TIMETOUSEFROM="${HOUR}:00:00"
TIMETOUSETO="${HOUR}:02:00"

if datetest ${NOW_IN_MYTIMEZONE} --lt ${TIMETOUSEFROM} || datetest ${NOW_IN_MYTIMEZONE} --gt ${TIMETOUSETO} ; then
   /home/user/bin/example-script.pl
# else  # debug 
#   echo "$SCRIPT is not running between ${TIMETOUSEFROM} and ${TIMETOUSETO}" # debug

fi


   
